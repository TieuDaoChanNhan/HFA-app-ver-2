import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/connect_hardware/controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final bLeController = Get.find<ConnectHardwareController>();
  StreamSubscription? subscription;
  bool _isNavigated = false;

  @override
  Widget build(BuildContext context) {
    if (result != null && !_isNavigated && mounted) {
      _isNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          navigateToConnectionPage(result!.code!);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Future navigateToConnectionPage(String remoteId) async {
    final remoteId = processString(result!.code!);
    bLeController.remoteId.value = remoteId.trim();
    try {
      await bLeController.scanDevice();
    } catch (e) {
      log(e.toString());
    }
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width / 2.4;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 25,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    subscription = controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() {
          result = scanData;
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không được quyền truy cập')),
      );
    }
  }

  @override
  void dispose() {
    subscription
        ?.cancel(); // Hủy listener để tránh gọi setState sau khi dispose
    controller?.dispose();
    super.dispose();
  }

  String processString(String s) {
    if (s.split(":").first != "CAREPORT") {
      return "";
    }
    return s.split(":").skip(1).join(":");
    // Lấy giá trị từ đường dẫn
  }
}
