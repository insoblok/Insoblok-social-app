// camera_page.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:insoblok/pages/stories/image_edit_designer.dart';

/// Simple camera page for capturing photos
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _permissionDenied = false;
  String? _errorMessage;
  bool _flashOn = false;

  double _zoom = 1.0;
  double _zoomStart = 1.0;
  static const double _minZoom = 1.0;
  double _maxZoom = 4.0;

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
      // Request camera permission
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
      enableAudio: false,
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
        await _controller!.setFlashMode(FlashMode.auto);
      }
      if (mounted) {
        setState(() => _flashOn = !_flashOn);
      }
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (mounted) {
        setState(() => _isLoading = true);
      }

      // Take picture
      final XFile photo = await _controller!.takePicture();

      if (mounted) {
        setState(() => _isLoading = false);
      }

      // Navigate to image editor with VSStoryDesigner
      if (mounted) {
        final editedImagePath = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => ImageEditorDesignerPage(path: photo.path),
          ),
        );

        // Return the edited image path (or original if user cancelled)
        if (mounted) {
          Navigator.of(context).pop(editedImagePath ?? photo.path);
        }
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture photo')),
        );
      }
    }
  }

  void _setZoom(double next) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final clamped = next.clamp(_minZoom, _maxZoom);
    if (clamped == _zoom) return;
    setState(() => _zoom = clamped);
    _controller!.setZoomLevel(clamped);
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
            if (_cameras.length > 1)
              IconButton(
                onPressed: _switchCamera,
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightTools() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 90, bottom: 140),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            InkWell(
              onTap: _toggleFlash,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    final canCapture = _isInitialized && !_isLoading;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Center(
          child: GestureDetector(
            onTap: canCapture ? _capturePhoto : null,
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: canCapture ? Colors.white : Colors.grey,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
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
                        'Capturing...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCaptureButton(),
          ),
        ],
      ),
    );
  }
}
