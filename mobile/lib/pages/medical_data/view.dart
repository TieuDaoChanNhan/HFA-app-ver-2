import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/pages/application/index.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';
import 'package:health_for_all/pages/medical_data/widget/more_data.dart';
import 'package:intl/intl.dart';

class MedicalDataPage extends GetView<MedicalDataController> {
  MedicalDataPage({super.key});
  RxBool isLoading = false.obs;
  final appController = Get.find<ApplicationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm dữ liệu y tế',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.normal,
            fontFamily: 'Roboto',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.outline,
            height: 0.7,
          ),
        ),
        actions: [
          Icon(
            Icons.add_to_photos_outlined,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _buildDateTimeField(context, 'Ngày', Icons.event_note,
                    controller.selectDate, controller.dateController,
                    width: MediaQuery.of(context).size.width / 5 * 3 - 2),
                _buildDateTimeField(context, 'Thời gian', Icons.schedule,
                    controller.selectTime, controller.timeController,
                    width: MediaQuery.of(context).size.width / 5 * 2 + 2),
              ],
            ),
            // _buildSearchField(context),
            const Divider(height: 2),
            ...controller.entries,
            // const MoreData(),
            const Divider(height: 1),
            _buildActionButtons(context),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField(
      BuildContext context,
      String label,
      IconData icon,
      Future<void> Function(BuildContext) onTap,
      TextEditingController controller,
      {required double width}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        readOnly: true,
        onTap: () => onTap(context),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainer,
      height: 72,
      child: Center(
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Tìm dữ liệu",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            suffixIcon: Icon(Icons.clear,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(context, "Hủy"),
            const SizedBox(width: 15),
            const VerticalDivider(width: 1, indent: 5, endIndent: 5),
            const SizedBox(width: 15),
            _buildActionButton(context, "Lưu"),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label) {
    return SizedBox(
      height: 40,
      width: (MediaQuery.of(context).size.width / 2) - 40,
      child: TextButton(
        onPressed: () async {
          if (label == 'Lưu') {
            isLoading.value = true;
            try {
              EasyLoading.show(status: "Đang xử lí...");
              if (isLoading.value) {
                Get.dialog(const Center(child: CircularProgressIndicator()));
              }
              log(isLoading.value.toString());
              // Perform the saving operation
              for (var value in controller.state.data.values) {
                if (value.imagePaths != null) {
                  for (var path in value.imagePaths!) {
                    final imageUrl =
                        await FirebaseApi.uploadImage(path, 'medicalData');
                    value.imageUrls?.add(imageUrl!);
                  }
                }
                log(value.toString());
                controller.checkAlarms(value.toFirestoreMap());
                await FirebaseApi.addDocument(
                    'medicalData', value.toFirestoreMap());
                if (value == controller.state.data.values.last) {
                  isLoading.value = false;
                  Get.back();
                }
                appController.getUpdatedLatestMedical();
              }

              // Clear the data after saving
              controller.state.data.clear();
              log(controller.state.data.toString());
              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thành công'),
                    content: const Text('Dữ liệu đã được ghi nhận'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          controller.dateController.text =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          controller.timeController.text =
                              DateFormat('hh:mm a').format(DateTime.now());
                          controller.state.data.clear();

                          Get.back(); // Dismiss the dialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              // Handle any errors
              print('Error saving data: $e');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Lỗi'),
                    content: const Text('Lỗi khi lưu dữ liệu. Hãy thử lại!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } finally {
              EasyLoading.dismiss();
            }
          }
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
