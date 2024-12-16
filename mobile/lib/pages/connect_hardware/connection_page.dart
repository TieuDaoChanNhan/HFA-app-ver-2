import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/connect_hardware/controller.dart';
import 'package:health_for_all/pages/connect_hardware/widget/data_fetched.dart';
import 'package:health_for_all/pages/connect_hardware/widget/ecg_fetched.dart';

class ConnectionPage extends GetView<ConnectHardwareController> {
  const ConnectionPage({super.key, required this.device});
  final ScanResult device;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ConnectHardwareController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(device.advertisementData.advName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            controller.scannedDevices.clear();
            controller.clearData();
            await controller.disconnectFromDevice(device.device);
            Get.back();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            children: [
              Center(
                  child: Column(
                children: [
                  const Text('Dữ liệu đo đã nhận'),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.state.medId.isEmpty) {
                      return const Center(child: Text('Không có dữ liệu.'));
                    }
                    // return ListView.builder(
                    //   itemCount: controller.state.medId.length,
                    //   itemBuilder: (context, index) {
                    //     return DataDay(
                    //         date: controller.state.medDate[index],
                    //         time: controller.state.medTime[index],
                    //         value: controller.state.medValue[index].toString(),
                    //         index: index,
                    //         pass: controller.state.medPass[index]);
                    //   },
                    // );
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < controller.state.medId.length;
                              i++)
                            if (controller.state.medValue[i].isNotEmpty&&controller.state.medValue[i].length > 1)
                              EcgFetched(
                                  date: controller.state.medDate[i],
                                  time: controller.state.medTime[i],
                                  value: controller.state.medValue[i],
                                  index: controller.state.medIndex[i]
                                      .map((e) => e.toString())
                                      .toList(),
                                  pass: controller.state.medPass[i], medId: controller.state.medId[i],)
                            else
                              DataFetched(
                                  date: controller.state.medDate[i],
                                  time: controller.state.medTime[i],
                                  value: controller.state.medValue[i],
                                  index: controller.state.medId[i],
                                  pass: controller.state.medPass[i])
                        ],
                      ),
                    );
                    // return Text(controller.state.medId.length.toString());
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // controller.clearData();
                    },
                    child: const Text('Xóa dữ liệu đã nhận'),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
