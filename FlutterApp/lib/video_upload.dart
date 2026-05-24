
import 'dart:convert';
import 'package:aura/home.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:io'; // For File class
import 'package:flutter/foundation.dart' show kIsWeb; // For kIsWeb

void main() {
  runApp(const video_upload());
}

class video_upload extends StatelessWidget {
  const video_upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: video_uploadPage(),
    );
  }
}

class video_uploadPage extends StatefulWidget {
  const video_uploadPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<video_uploadPage> with SingleTickerProviderStateMixin {
  PlatformFile? _selectedFile;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isUploading = false;
  Map<String, dynamic>? _backendResponse;
  String? _errorMessage;
  String output = "";

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _videoController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer(String filePath) async {
    _videoController = VideoPlayerController.file(
      File(filePath),
    );

    try {
      await _videoController!.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
      _videoController!.setLooping(true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not initialize video player: $e';
      });
    }
  }

  Future<void> _pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _backendResponse = null;
          _errorMessage = null;
          _isVideoInitialized = false;
        });

        // Initialize video player for the selected file
        if (!kIsWeb && _selectedFile!.path != null) {
          await _initializeVideoPlayer(_selectedFile!.path!);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error selecting file: $e';
      });
    }
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
        Uri.parse("$ip/process_video"),
      );

      // ✅ FIX: Check platform and use appropriate method
      if (kIsWeb) {
        // Web platform - use bytes
        if (_selectedFile!.bytes == null) {
          throw Exception('File bytes not available on web');
        }
        request.files.add(
          http.MultipartFile.fromBytes(
            'video_file',
            _selectedFile!.bytes!,
            filename: _selectedFile!.name,
          ),
        );
      } else {
        // Mobile/Desktop platform - use file path
        if (_selectedFile!.path == null) {
          throw Exception('File path not available');
        }
        request.files.add(
          await http.MultipartFile.fromPath(
            'video_file',
            _selectedFile!.path!,
            filename: _selectedFile!.name,
          ),
        );
      }

      // Send the request with timeout
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 300),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prediction = data['prediction'] ?? 'Unknown';

        setState(() {
          _backendResponse = data;
          output = prediction;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(child: Text('Analysis complete: $prediction')),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Server error (${response.statusCode}): ${response.body}';
        });
      }
    } catch (e) {
      print('Upload error: $e');
      setState(() {
        _errorMessage = 'Upload failed: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
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
          'Video Analysis',
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
                          Icons.videocam_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Center(
                      child: Text(
                        'Video Classifier',
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
                        'Upload a video for AI analysis',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // File Picker Card
                    GestureDetector(
                      onTap: _pickVideoFile,
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
                                  : Icons.video_file_outlined,
                              size: 60,
                              color: _selectedFile != null
                                  ? Colors.green
                                  : const Color(0xFF4158D0),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFile != null
                                  ? 'Video Selected!'
                                  : 'Select Video File',
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
                                'MP4, MOV, AVI, MKV supported',
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
                                    Icons.video_file,
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
                                        '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB • ${_selectedFile!.extension?.toUpperCase() ?? 'VIDEO'}',
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
                                    setState(() {
                                      _selectedFile = null;
                                      _videoController?.dispose();
                                      _videoController = null;
                                      _isVideoInitialized = false;
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

                    // Video Player Section
                    if (_isVideoInitialized && _videoController != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoPlayer(_videoController!),
                                _VideoControls(controller: _videoController!),
                              ],
                            ),
                          ),
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
                                'PROCESSING VIDEO...',
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
                                'ANALYZE VIDEO',
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
                                    'Video Classification',
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

class _VideoControls extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoControls({Key? key, required this.controller}) : super(key: key);

  @override
  __VideoControlsState createState() => __VideoControlsState();
}

class __VideoControlsState extends State<_VideoControls> {
  late VideoPlayerController _controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _controller.value.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
            Expanded(
              child: Slider(
                value: _controller.value.position.inMilliseconds.toDouble(),
                min: 0,
                max: _controller.value.duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  _controller.seekTo(Duration(milliseconds: value.toInt()));
                },
                activeColor: const Color(0xFF4158D0),
                inactiveColor: Colors.white.withOpacity(0.3),
              ),
            ),
            Text(
              '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }
}