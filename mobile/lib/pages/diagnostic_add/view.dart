import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/add_file.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/diagnostic_text.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/from_doctor.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/send_diagnostic.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/type_of_data.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:image_picker/image_picker.dart';

class DiagnosticAddView extends StatelessWidget {
  DiagnosticAddView({
    super.key,
    required this.user,
    required this.medicalData,
  });
  final notiController = Get.find<NotificationController>();
  final MedicalEntity medicalData;
  final UserData user;
  final diagnosticController = Get.find<DiagnosticAddController>();

  void updateFiles(List<XFile> newFiles) {
    diagnosticController.selectedFiles.assignAll(newFiles);
    for (var file in diagnosticController.selectedFiles) {
      log('combobox: ${file.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Thêm chẩn đoán'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SendDiagnostic(user: user),
                      const SizedBox(height: 16),
                      TypeOfData(medicalData: medicalData),
                      const SizedBox(height: 16),
                      DiagnosticText(),
                      const SizedBox(height: 16),
                      AddFile(
                        files: diagnosticController.selectedFiles,
                        onFilesChanged: updateFiles,
                      ),
                    ],
                  ),
                ),
              ),
              FromDoctor(
                doctorname: diagnosticController
                        .appController.state.profile.value?.name ??
                    "",
              ),
              _buildActionButtons(context),
            ],
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
            _buildActionButton(context, "Gửi"),
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
          FocusScope.of(context).unfocus();
          if (label == 'Gửi') {
            await _handleSave(context);
          } else {
            Get.back();
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

  Future<void> _handleSave(BuildContext context) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Perform the saving operation
      await diagnosticController.addImage();
      final docId = await diagnosticController.addDiagnostic(
        medicalData.id!,
        user.id!,
      );
      FirebaseMessagingApi.sendMessage(
          user.fcmtoken!,
          'Chẩn đoán',
          "${diagnosticController.appController.state.profile.value!.name!} đã gửi chẩn đoán đến bạn",
          'diagnostic',
          '/diagnotic',
          user.id!,
          'unread',
          diagnosticId: docId,
          medicalId: medicalData.id!);

      Future.delayed(const Duration(seconds: 1), () {
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: Text(
                    'Thành công thêm chẩn đoán cho bệnh nhân ${user.name!}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close success dialog
                      Get.back(); // Navigate back
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });

      // Clear the data after saving
      diagnosticController.selectedFiles.clear();
      diagnosticController.selectedImagesURL.clear();
    } catch (e) {
      // Handle any errors
      log('Error saving data: $e');
      _showErrorDialog(context);
    }
    finally{
      EasyLoading.dismiss();
    }
  }

  void _showErrorDialog(BuildContext context) {
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
  }
}
