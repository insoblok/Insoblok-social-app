import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:insoblok/routers/router.dart';

/// TikTok-like create post capture screen using standard camera.
/// - Record up to 30 seconds of video
/// - Switch to Text mode to redirect to Add Story page
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isLoading = false;
  bool _permissionDenied = false;
  String? _errorMessage;
  bool _flashOn = false;

  int _maxSeconds = 30;
  int _remaining = 0;
  Timer? _ticker;

  int _preCountdownSeconds = 0;
  int _preCountdownRemaining = 0;
  Timer? _preTimer;

  double _zoom = 1.0;
  double _zoomStart = 1.0;
  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _permissionDenied = false;
      });
    }

    try {
      // Request permissions
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _permissionDenied = true;
            _errorMessage =
                'Camera permission is required. Please enable it in app settings.';
          });
        }
        return;
      }

      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        debugPrint('⚠️ Microphone permission not granted');
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw StateError('No cameras available on this device');
      }

      // Initialize camera
      await _initCameraController();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _initCameraController() async {
    if (_cameras.isEmpty) return;

    // Dispose existing controller
    await _controller?.dispose();

    final camera = _cameras[_selectedCameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initCameraController();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
      }
      if (mounted) {
        setState(() => _flashOn = !_flashOn);
      }
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _startRecording() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isRecording) {
      return;
    }

    try {
      await _controller!.startVideoRecording();
      if (mounted) {
        setState(() {
          _isRecording = true;
          _remaining = _maxSeconds;
        });
      }

      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        if (_remaining <= 1) {
          _stopRecording(autoProceed: true);
        } else {
          setState(() => _remaining -= 1);
        }
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      if (mounted) {
        setState(() => _isRecording = false);
      }
    }
  }

  Future<void> _stopRecording({bool autoProceed = false}) async {
    if (!_isRecording || _controller == null) return;

    _ticker?.cancel();
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isRecording = false;
      });
    }

    try {
      final file = await _controller!.stopVideoRecording();
      if (mounted) {
        setState(() {
          _remaining = 0;
          _isLoading = false;
        });
      }

      if (autoProceed && file.path.isNotEmpty) {
        Routers.goToVideoEditorPage(context, file.path);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _startWithPreTimerOrRecord() async {
    if (_preCountdownSeconds <= 0) {
      await _startRecording();
      return;
    }
    setState(() => _preCountdownRemaining = _preCountdownSeconds);
    _preTimer?.cancel();
    _preTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return t.cancel();
      if (_preCountdownRemaining <= 1) {
        t.cancel();
        if (!mounted) return;
        setState(() => _preCountdownRemaining = 0);
        await _startRecording();
      } else {
        setState(() => _preCountdownRemaining -= 1);
      }
    });
  }

  void _setZoom(double next) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final clamped = next.clamp(_minZoom, _maxZoom);
    if (clamped == _zoom) return;
    setState(() => _zoom = clamped);
    _controller!.setZoomLevel(clamped);
  }

  void _chooseTimer() {
    if (_isRecording || _isLoading) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        Widget item(String label, int sec) {
          final selected = _preCountdownSeconds == sec;
          return ListTile(
            title: Text(
              label,
              style: TextStyle(color: selected ? Colors.pink : Colors.white),
            ),
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _preCountdownSeconds = sec);
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [item('Off', 0), item('3s', 3), item('10s', 10)],
          ),
        );
      },
    );
  }

  Widget _buildRightTools() {
    Widget circle(IconData icon, VoidCallback? onTap, {Color? color}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? Colors.white),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 90, bottom: 140),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            circle(
              Icons.cameraswitch,
              _cameras.length > 1 ? _switchCamera : null,
            ),
            circle(
              Icons.timer,
              _chooseTimer,
              color: _preCountdownSeconds > 0 ? Colors.pink : null,
            ),
            circle(_flashOn ? Icons.flash_on : Icons.flash_off, _toggleFlash),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final durations = const [15, 30, 60];
    int currentIndex = durations.indexOf(_maxSeconds);
    if (currentIndex < 0) currentIndex = 1;

    Widget chip(int seconds, bool selected) {
      return GestureDetector(
        onTap:
            _isRecording || _isLoading
                ? null
                : () {
                  setState(() => _maxSeconds = seconds);
                },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.pink : Colors.white24,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${seconds}s',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        chip(15, currentIndex == 0),
        chip(30, currentIndex == 1),
        chip(60, currentIndex == 2),
      ],
    );
  }

  Widget _buildCaptureBar() {
    final canCapture = _isInitialized && !_isLoading;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDurationSelector(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:
                      !canCapture
                          ? null
                          : () async {
                            if (_isRecording) {
                              await _stopRecording(autoProceed: true);
                            } else {
                              await _startWithPreTimerOrRecord();
                            }
                            if (mounted) setState(() {});
                          },
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (_isRecording)
              Text(
                '$_remaining s',
                style: const TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _preTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_permissionDenied || _errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _permissionDenied
                          ? Icons.camera_alt_outlined
                          : Icons.error_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage ?? 'Camera permission denied',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    if (_permissionDenied)
                      ElevatedButton(
                        onPressed: () async {
                          await openAppSettings();
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              _initializeCamera();
                            }
                          });
                        },
                        child: const Text('Open Settings'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          _initializeCamera();
                        },
                        child: const Text('Retry'),
                      ),
                  ],
                ),
              ),
            )
          else if (_isInitialized &&
              _controller != null &&
              _controller!.value.isInitialized)
            Positioned.fill(
              child: GestureDetector(
                onScaleStart: (d) => _zoomStart = _zoom,
                onScaleUpdate: (d) {
                  if (d.scale != 1.0) {
                    _setZoom(_zoomStart * d.scale);
                  }
                },
                child: CameraPreview(_controller!),
              ),
            )
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Initializing camera...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

          _buildTopBar(),
          _buildRightTools(),

          if (_preCountdownRemaining > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Text(
                    '$_preCountdownRemaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          if (_isLoading && _isInitialized)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Processing...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Align(alignment: Alignment.bottomCenter, child: _buildCaptureBar()),
        ],
      ),
    );
  }
}
