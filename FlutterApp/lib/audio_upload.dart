// import 'dart:convert';
// import 'package:aura/home.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main(){
//   runApp(audio_upload());
// }
//
// class audio_upload extends StatelessWidget {
//   const audio_upload({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:AudioUploadPage());
//   }
// }
//
// class AudioUploadPage extends StatefulWidget {
//   @override
//   _AudioUploadPageState createState() => _AudioUploadPageState();
// }
//
// class _AudioUploadPageState extends State<AudioUploadPage> {
//
//   PlatformFile? _selectedFile;
//   bool _isUploading = false;
//   Map<String, dynamic>? _backendResponse;
//   String? _errorMessage;
//   String output="";
//
//   // Function to select an audio file using the system's file picker
//   Future<void> _pickAudioFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.audio, // Filter to show only audio files[citation:1][citation:5]
//         allowMultiple: false,
//       );
//
//       if (result != null) {
//         setState(() {
//           _selectedFile = result.files.first;
//           _backendResponse = null; // Clear previous response
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error selecting file: $e';
//       });
//     }
//   }
//
//   // Function to send the selected file to the Django backend
//   Future<void> _uploadToBackend() async {
//     if (_selectedFile == null) return;
//
//     setState(() {
//       _isUploading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       // Prepare the multipart request
//       SharedPreferences sh= await SharedPreferences.getInstance();
//
//       var request = http.MultipartRequest('POST', Uri.parse("${sh.getString("ip").toString()}/process_audio"));
//       // var request = http.MultipartRequest('POST', Uri.parse("http://192.168.29.36:5000/process_audio"));
//
//       // Attach the file. The bytes are loaded into memory[citation:1].
//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'audio_file', // This key must match the field name in your Django view
//           _selectedFile!.bytes!,
//           filename: _selectedFile!.name,
//         ),
//       );
//
//       // Send the request
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         // Parse the successful JSON response
//         setState(() {
//           _backendResponse = json.decode(response.body);
//           final data = jsonDecode(response.body);
//           final prediction = data['prediction'];
//           print("Hello");
//           print(prediction);
//           setState(() {
//             output=prediction;
//           });
//         });
//       } else {
//         // Handle server errors
//         setState(() {
//           _errorMessage = 'Server error (${response.statusCode}): ${response.body}';
//         });
//       }
//     } catch (e) {
//       // Handle network or request errors
//       setState(() {
//         _errorMessage = 'Upload failed: $e';
//       });
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
//             },
//           ),
//           title: Text('Audio Processor')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // File Picker Button
//             ElevatedButton.icon(
//               icon: Icon(Icons.audio_file),
//               label: Text('SELECT AUDIO FILE'),
//               onPressed: _pickAudioFile,
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.deepPurple,
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Selected File Info
//             if (_selectedFile != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('📄 Selected File:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Text('Name: ${_selectedFile!.name}'),
//                       Text('Size: ${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB'),
//                       Text('Extension: ${_selectedFile!.extension ?? 'N/A'}'),
//                     ],
//                   ),
//                 ),
//               ),
//             SizedBox(height: 20),
//
//             // Upload Button
//             ElevatedButton.icon(
//               icon: _isUploading ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Icon(Icons.cloud_upload),
//               label: Text(_isUploading ? 'PROCESSING...' : 'SEND TO BACKEND'),
//               onPressed: (_selectedFile != null && !_isUploading) ? _uploadToBackend : null,
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.green,
//               ),
//             ),
//
//             // Error Message Display
//             if (_errorMessage != null)
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red),
//                 ),
//                 child: Text('❌ $_errorMessage', style: TextStyle(color: Colors.red[800])),
//               ),
//
//             // Backend Response Display
//             if (_backendResponse != null)
//               Container(
//                 margin: EdgeInsets.only(top: 30),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('✅ Backend Response:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
//                     SizedBox(height: 10),
//                     Text(
//                       "Cat audio classified as "+output,
//                       style: TextStyle(fontFamily: 'monospace', fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:aura/home.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

void main() {
  runApp(const audio_upload());
}

class audio_upload extends StatelessWidget {
  const audio_upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AudioUploadPage(),
    );
  }
}

class AudioUploadPage extends StatefulWidget {
  const AudioUploadPage({Key? key}) : super(key: key);

  @override
  _AudioUploadPageState createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> with SingleTickerProviderStateMixin {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  Map<String, dynamic>? _backendResponse;
  String? _errorMessage;
  String output = "";

  // Audio Player
  AudioPlayer? _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlayerReady = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer!.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer!.onPlayerStateChanged.listen((state) {
      setState(() => _playerState = state);
    });

    _audioPlayer!.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // ✅ Change to FileType.custom
        allowMultiple: false,
        allowedExtensions: ['mp3', 'wav', 'aac', 'ogg', 'm4a', 'flac'], // ✅ This works with custom
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _backendResponse = null;
          _errorMessage = null;
          _isPlayerReady = false;
          _position = Duration.zero;
          _duration = Duration.zero;
        });

        // Load audio file for mobile
        if (_selectedFile!.path != null) {
          await _loadAudioFile(File(_selectedFile!.path!));
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error selecting file: $e';
      });
    }
  }

  Future<void> _loadAudioFile(File audioFile) async {
    try {
      await _audioPlayer?.setSourceDeviceFile(audioFile.path);
      _duration = await _audioPlayer?.getDuration() ?? Duration.zero;
      setState(() {
        _isPlayerReady = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not load audio file: $e';
      });
    }
  }

  Future<void> _playAudio() async {
    await _audioPlayer?.resume();
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer?.pause();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer?.stop();
    setState(() {
      _position = Duration.zero;
    });
  }

  Future<void> _seekAudio(double value) async {
    final position = Duration(milliseconds: value.toInt());
    await _audioPlayer?.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _uploadToBackend() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final ip = sh.getString("ip") ?? "";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$ip/process_audio"),
      );

      // ✅ FIX: For mobile, use file path instead of bytes
      if (_selectedFile!.path != null) {
        // Mobile - use file path
        request.files.add(
          await http.MultipartFile.fromPath(
            'audio_file',
            _selectedFile!.path!,
            filename: _selectedFile!.name,
          ),
        );
      } else if (_selectedFile!.bytes != null) {
        // Web - use bytes
        request.files.add(
          http.MultipartFile.fromBytes(
            'audio_file',
            _selectedFile!.bytes!,
            filename: _selectedFile!.name,
          ),
        );
      } else {
        throw Exception('No file data available');
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prediction = data['prediction'];

        setState(() {
          _backendResponse = data;
          output = prediction;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Analysis complete: $prediction'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Server error (${response.statusCode}): ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Upload failed: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
        ),
        title: const Text(
          'Audio Analysis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0A0E21),
                  const Color(0xFF1A1F35),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4158D0).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.audiotrack_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Center(
                      child: Text(
                        'Audio Classifier',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Upload audio for AI analysis',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // File Picker Card
                    GestureDetector(
                      onTap: _pickAudioFile,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedFile != null
                                ? Colors.green.withOpacity(0.5)
                                : const Color(0xFF4158D0).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _selectedFile != null
                                  ? Icons.check_circle_outline
                                  : Icons.audio_file_outlined,
                              size: 60,
                              color: _selectedFile != null
                                  ? Colors.green
                                  : const Color(0xFF4158D0),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFile != null
                                  ? 'Audio Selected!'
                                  : 'Select Audio File',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedFile != null
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_selectedFile == null) ...[
                              Text(
                                'MP3, WAV, AAC, OGG, M4A, FLAC supported',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to browse files',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selected File Info
                    if (_selectedFile != null) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4158D0).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.audio_file,
                                    color: Color(0xFF4158D0),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedFile!.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB • ${_selectedFile!.extension?.toUpperCase() ?? 'AUDIO'}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _stopAudio();
                                    setState(() {
                                      _selectedFile = null;
                                      _isPlayerReady = false;
                                      _position = Duration.zero;
                                      _duration = Duration.zero;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Audio Player Section
                    if (_isPlayerReady && _selectedFile != null) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4158D0).withOpacity(0.2),
                              const Color(0xFFC850C0).withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Waveform Animation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(30, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 3,
                                  height: _playerState == PlayerState.playing
                                      ? 20 + (index % 5) * 4.0
                                      : 12,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),

                            // Time Display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            // Progress Slider
                            SliderTheme(
                              data: SliderThemeData(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                                activeTrackColor: const Color(0xFF4158D0),
                                inactiveTrackColor: Colors.white.withOpacity(0.2),
                                thumbColor: Colors.white,
                                overlayColor: const Color(0xFF4158D0).withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _position.inMilliseconds.toDouble(),
                                min: 0,
                                max: _duration.inMilliseconds.toDouble(),
                                onChanged: _seekAudio,
                              ),
                            ),

                            // Playback Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.skip_previous_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    _seekAudio(0);
                                  },
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _playerState == PlayerState.playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    iconSize: 48,
                                    onPressed: () {
                                      if (_playerState == PlayerState.playing) {
                                        _pauseAudio();
                                      } else {
                                        _playAudio();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(
                                    Icons.stop_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: _stopAudio,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Upload Button
                    if (_selectedFile != null) ...[
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _uploadToBackend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4158D0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isUploading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'PROCESSING AUDIO...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_rounded),
                              SizedBox(width: 10),
                              Text(
                                'ANALYZE AUDIO',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade400,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Backend Response / Result Card
                    if (_backendResponse != null) ...[
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4158D0).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.analytics_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Analysis Result',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Audio Classification',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      output.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: LinearProgressIndicator(
                                      value: 0.95,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      color: Colors.white,
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '95% Confidence',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}