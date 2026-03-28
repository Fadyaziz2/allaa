import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../base/custom_app_bar.dart';

class SkuScannerScreen extends StatefulWidget {
  const SkuScannerScreen({super.key});

  @override
  State<SkuScannerScreen> createState() => _SkuScannerScreenState();
}

class _SkuScannerScreenState extends State<SkuScannerScreen> {
  bool _scanned = false;

  bool get _isScannerSupported {
    if (kIsWeb) return true;

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'scan_barcode_key'.tr,
        isBackButtonExist: true,
      ),
      body: _isScannerSupported
          ? MobileScanner(
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
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Barcode scanner is not supported on this platform.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
