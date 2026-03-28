import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../base/custom_app_bar.dart';

class SkuScannerScreen extends StatefulWidget {
  const SkuScannerScreen({super.key});

  @override
  State<SkuScannerScreen> createState() => _SkuScannerScreenState();
}

class _SkuScannerScreenState extends State<SkuScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  bool _scanned = false;
  bool _isLoading = true;
  bool _hasCameraPermission = false;
  bool _isPermissionPermanentlyDenied = false;
  bool _isScannerPluginAvailable = true;
  String? _errorMessage;

  bool get _isScannerSupported {
    if (kIsWeb) return true;

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _prepareScanner();
  }

  Future<void> _prepareScanner() async {
    if (!_isScannerSupported) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final permissionGranted = await _ensureCameraPermission();
      if (!permissionGranted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await _scannerController.start();
      setState(() {
        _isLoading = false;
      });
    } on MissingPluginException {
      setState(() {
        _isScannerPluginAvailable = false;
        _errorMessage =
            'Mobile scanner plugin is not registered. Please run "flutter clean", "flutter pub get", then build again.';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isScannerPluginAvailable = false;
        _errorMessage = e.message ??
            'Unable to initialize camera scanner. Please rebuild the app and try again.';
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isScannerPluginAvailable = false;
        _errorMessage =
            'Unexpected error while opening camera scanner. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<bool> _ensureCameraPermission() async {
    if (kIsWeb) {
      _hasCameraPermission = true;
      _isPermissionPermanentlyDenied = false;
      return true;
    }

    var status = await Permission.camera.status;
    if (status.isGranted) {
      _hasCameraPermission = true;
      _isPermissionPermanentlyDenied = false;
      return true;
    }

    status = await Permission.camera.request();
    _hasCameraPermission = status.isGranted;
    _isPermissionPermanentlyDenied = status.isPermanentlyDenied;

    return _hasCameraPermission;
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'scan_barcode_key'.tr,
        isBackButtonExist: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isScannerSupported) {
      return _buildInfoMessage(
          'Barcode scanner is not supported on this platform.');
    }

    if (!_hasCameraPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Camera permission is required to scan barcode.',
                textAlign: TextAlign.center,
              ),
              if (_isPermissionPermanentlyDenied) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: openAppSettings,
                  child: const Text('Open App Settings'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (!_isScannerPluginAvailable) {
      return _buildInfoMessage(_errorMessage ??
          'Scanner plugin is not available in this build. Rebuild the app.');
    }

    return MobileScanner(
      controller: _scannerController,
      onDetect: (capture) {
        if (_scanned) {
          return;
        }

        final code = capture.barcodes.first.rawValue;
        if (code == null || code.isEmpty) {
          return;
        }

        _scanned = true;
        Get.back(result: code);
      },
    );
  }

  Widget _buildInfoMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
