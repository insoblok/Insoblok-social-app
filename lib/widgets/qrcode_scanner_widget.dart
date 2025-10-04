import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:insoblok/services/services.dart';


typedef QRScanCallback = void Function(String result);

class QRScanner extends StatefulWidget {
  final QRScanCallback onQRScanned;
  final String? title;
  final String? instructions;
  final Color? overlayColor;
  final double cutOutSize;
  final bool autoCloseOnScan;
  final Widget? customAppBar;
  final List<Widget>? customActions;

  const QRScanner({
    Key? key,
    required this.onQRScanned,
    this.title = 'QR Code Scanner',
    this.instructions = 'Align QR code within the frame',
    this.overlayColor,
    this.cutOutSize = 250,
    this.autoCloseOnScan = true,
    this.customAppBar,
    this.customActions,
  }) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _hasPermission = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    Future.delayed(Duration(milliseconds: 1000), () {
      logger.d('This runs after 1 second');
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (_controller != null) {
      _controller!.pauseCamera();
      _controller!.resumeCamera();
    }
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
    } else {
      _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      logger.d("QRCode is scanned.");
      if (scanData.code != null) {
        widget.onQRScanned(scanData.code!);
        
        if (widget.autoCloseOnScan) {
          Navigator.of(context).pop();
        } else {
          // Pause camera to prevent multiple scans
          controller.pauseCamera();
        }
      }
    });
  }

  Future<void> _toggleFlash() async {
    await _controller?.toggleFlash();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _flipCamera() async {
    await _controller?.flipCamera();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Camera Permission Required',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'This app needs camera access to scan QR codes',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                child: Text('Grant Permission'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanner() {
    return Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: widget.overlayColor ?? Colors.green,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 5,
                    cutOutSize: widget.cutOutSize,
                  ),
                ),
                if (widget.instructions != null)
                  Positioned(
                    bottom: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.instructions!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!widget.autoCloseOnScan)
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _toggleFlash,
                    icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
                    label: Text(_isFlashOn ? 'Flash On' : 'Flash Off'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _flipCamera,
                    icon: Icon(Icons.cameraswitch),
                    label: Text(_isFrontCamera ? 'Back Camera' : 'Front Camera'),
                  ),
                ],
              ),
            ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionDenied();
    }
    return _buildScanner();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}