import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/connect_hardware/controller.dart';
import 'package:health_for_all/pages/connect_hardware/qr_code_scan.dart';
import 'package:health_for_all/pages/samsung_connect/view.dart';

import 'connection_page.dart';

class ConnectHardwarePage extends GetView<ConnectHardwareController> {
  const ConnectHardwarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connect Hardware',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 22,
          ),
        ),
        actions: [
          Icon(
            Icons.help_outline,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                find_device(context),
                const SizedBox(
                  height: 16,
                ),
                connect_samsung(context),
                const SizedBox(
                  height: 16,
                ),
                Obx(() {
                  if (controller.scannedDevices.isNotEmpty) {
                    return Column(
                      children: [
                        const Text('Thiết bị đã quét'),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.scannedDevices.length,
                          itemBuilder: (context, index) {
                            final device = controller.scannedDevices[index];
                            return ListTile(
                              title: Text(device.advertisementData.advName),
                              subtitle: Text(device.device.remoteId.toString()),
                              onTap: () async {
                                await controller
                                    .connectToDevice(device.device)
                                    .then((value) {
                                  Get.to(() => ConnectionPage(device: device));
                                });
                              },
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget find_device(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var adapterState = await FlutterBluePlus.adapterState.first;

        if (adapterState != BluetoothAdapterState.on) {
          await FlutterBluePlus.turnOn();
          // Kiểm tra lại sau khi cố gắng bật BLE
          adapterState = await FlutterBluePlus.adapterState.first;
        }

        if (adapterState == BluetoothAdapterState.on) {
          Get.to(() => const ScanQrScreen());
        } else {
          // Thêm logic xử lý nếu không bật được BLE (ví dụ: hiện thông báo)
          Get.snackbar('Lỗi', 'Không thể bật Bluetooth.');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
              // offset: Offset(0, 3), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.manage_search,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Tìm kiếm thiết bị",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget connect_samsung(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const HealthConnect());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
            )
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/samsung_health.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Kết nối với Samsung Health",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
