// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   static Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'location_channel', // channel id
//       'Location Updates', // channel name
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'location_payload',
//     );
//   }
// }
//
// class LocationService {
//   StreamSubscription<Position>? _positionStreamSubscription;
//
//
//   // Start listening to location updates
//   Future<void> startLocationUpdates(String userId) async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw 'Location services are disabled.';
//     }
//
//     // Check for permission, request if not granted
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw 'Location permissions are denied';
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw 'Location permissions are permanently denied.';
//     }
//
//     // Subscribe to position updates
//     _positionStreamSubscription = Geolocator.getPositionStream(
//       locationSettings: LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1, // meters - update only if moved 10 meters
//       ),
//     ).listen((Position position) {
//
//       _sendLocationToServer(position, userId);
//     });
//   }
//
//   // Stop listening to location updates
//   void stopLocationUpdates() {
//     _positionStreamSubscription?.cancel();
//   }
//   Function(String)? onNotificationMessage;
//
//   // Send location data to Django server via POST
//   Future<void> _sendLocationToServer(Position position, String userId) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       final ip = sh.getString("ip") ?? "";
//       final uid = sh.getString("uid") ?? "";
//
//       if (ip.isEmpty) {
//         throw Exception('Server IP not configured');
//       }
//       // Django server URL to POST location data
//       final String serverUrl = "$ip/check_vaccine_notification";
//
//       sh.setString("latitude", position.latitude.toString());
//       sh.setString("longitude", position.longitude.toString());
//
//       final response = await http.post(
//         Uri.parse(serverUrl),
//         body: {
//           'uid': uid,
//           'lastid': sh.getString("lastid")??"0",
//         },
//       );
//
//
//       var jsondata=json.decode(response.body);
//       if (jsondata['status']=="ok") {
//         onNotificationMessage?.call("📍 "+jsondata['msg']);
//         sh.setString("lastid", jsondata['id'].toString());
//
//         print('New notification for today successfully');
//       } else {
//         print('No new notifications');
//       }
//     } catch (e) {
//       print('Error sending location: $e');
//     }
//   }
// }


import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'vaccination_channel',
      'Vaccination Notifications',
      channelDescription: 'Channel for vaccination reminders',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'vaccination_payload',
    );
  }
}

class LocationService {
  Timer? _timer;
  Position? _currentPosition;
  bool _isRunning = false;
  String? _userId;

  // Callback for notifications
  Function(String)? onNotificationMessage;

  // Check and request location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Services are disabled. Please enable services.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied. Please enable them in app settings.';
    }

    return true;
  }

  // Start periodic location checks every 15 seconds
  Future<void> startLocationUpdates(String userId) async {
    if (_isRunning) {
      print('Service is already running');
      return;
    }

    try {
      // Handle permissions first
      await _handleLocationPermission();

      _userId = userId;
      _isRunning = true;

      // Get initial location
      await _updateCurrentLocation();

      // Start timer for 15-second intervals
      _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
        await _updateCurrentLocation();
        if (_currentPosition != null && _userId != null) {
          await _checkVaccineNotification(_userId!);
        }
      });

      print('📍 Service started - checking every 15 seconds');

      // Show notification that service started
      onNotificationMessage?.call('📍 Service started');

    } catch (e) {
      _isRunning = false;
      print('Error starting service: $e');
      rethrow;
    }
  }

  // Update current position
  Future<void> _updateCurrentLocation() async {
    try {
      // Get current position using geolocator 11.1.0
      // For geolocator 11.1.0, we use position settings in getCurrentPosition
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Store in SharedPreferences
      SharedPreferences sh = await SharedPreferences.getInstance();
      await sh.setString("latitude", _currentPosition!.latitude.toString());
      await sh.setString("longitude", _currentPosition!.longitude.toString());

      print('📍 Location updated: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');

    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  // Alternative method using position stream if you want continuous updates
  StreamSubscription<Position>? _positionStreamSubscription;

  // Alternative: Start continuous location updates using stream
  Future<void> startContinuousLocationUpdates(String userId) async {
    if (_isRunning) return;

    try {
      await _handleLocationPermission();

      _userId = userId;
      _isRunning = true;

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // Update every time location changes
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        _currentPosition = position;
        _saveLocation(position);
        _checkVaccineNotification(userId);
      });

      print('📍 Continuous location service started');

    } catch (e) {
      _isRunning = false;
      print('Error starting continuous location service: $e');
    }
  }

  // Save location to SharedPreferences
  Future<void> _saveLocation(Position position) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      await sh.setString("latitude", position.latitude.toString());
      await sh.setString("longitude", position.longitude.toString());
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  // Stop the periodic timer
  void stopLocationUpdates() {
    _timer?.cancel();
    _timer = null;

    // Also cancel stream subscription if it exists
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    _isRunning = false;
    _userId = null;
    print('📍 Location service stopped');

    // Show notification that service stopped
    onNotificationMessage?.call('📍 Location tracking stopped');
  }

  // Check vaccine notification
  Future<void> _checkVaccineNotification(String userId) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final ip = sh.getString("ip") ?? "";
      final uid = sh.getString("uid") ?? "";

      if (ip.isEmpty) {
        throw Exception('Server IP not configured');
      }

      final String serverUrl = "$ip/check_vaccine_notification";

      print('🔍 Checking for notifications at ${DateTime.now()}');

      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'uid': uid,
          'lastid': sh.getString("lastid") ?? "0",
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);

        if (jsondata['status'] == "ok") {
          String message = "📍 " + jsondata['msg'];

          // Show notification via callback
          onNotificationMessage?.call(message);

          // Also show local notification
          await NotificationHelper.showNotification(
            'Vaccination Reminder',
            jsondata['msg'],
          );

          // Update lastid
          await sh.setString("lastid", jsondata['id'].toString());

          print('✅ New notification received: ${jsondata['msg']}');
        } else {
          print('ℹ️ No new notifications at ${DateTime.now()}');
        }
      } else {
        print('❌ Server error: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Error checking vaccine notification: $e');
    }
  }

  // Check if service is running
  bool get isRunning => _isRunning;

  // Get current position
  Position? get currentPosition => _currentPosition;

  // Get last update time
  DateTime? get lastUpdateTime => _currentPosition?.timestamp;
}

// Easy to use service manager
class LocationServiceManager {
  static final LocationService _service = LocationService();

  static LocationService get instance => _service;

  static Future<void> start() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String uid = sh.getString('uid') ?? '';

      if (uid.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      await _service.startLocationUpdates(uid);

    } catch (e) {
      print('Failed to start location service: $e');
      rethrow;
    }
  }

  static void stop() {
    _service.stopLocationUpdates();
  }

  static bool get isRunning => _service.isRunning;

  static Position? get currentPosition => _service.currentPosition;
}