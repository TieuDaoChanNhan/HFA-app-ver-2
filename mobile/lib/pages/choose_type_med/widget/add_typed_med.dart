import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/choose_type_med/controller.dart';
import 'package:image_picker/image_picker.dart';

import 'add_file.dart';

class AddTypedMed extends StatefulWidget {
  const AddTypedMed({super.key});

  @override
  State<AddTypedMed> createState() => _AddTypedMedState();
}

class _AddTypedMedState extends State<AddTypedMed> {
  final medicineController = Get.find<ChooseTypeMedController>();
  void updateFiles(List<XFile> newFiles) {
    medicineController.selectedFiles.assignAll(newFiles);
    for (var file in medicineController.selectedFiles) {
      log('combobox: ${file.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        header(),
        body(),
        build_button(),
      ],
    );
  }

  Widget header() {
    return Row(
      children: [
        Icon(
          Icons.medication_liquid_sharp,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          "Thêm loại thuốc",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(children: [
        _buildDialogTextField("Tên loại thuốc", "Tên loại thuốc",
            medicineController.nameMedicine),
        const SizedBox(
          height: 24,
        ),
        _buildDialogTextField("Mô tả", "Công dụng, cách dùng, liều lượng",
            medicineController.description,
            maxLines: 3),
        const SizedBox(
          height: 24,
        ),
        AddFile(
          files: medicineController.selectedFiles,
          onFilesChanged: updateFiles,
        ),
      ]),
    );
  }

  Widget _buildDialogTextField(
      String label, String hint, TextEditingController controller,
      {int? maxLines}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: TextField(
        controller: controller,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 16,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget build_button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            medicineController.clearData();
            Get.back();
          },
          child: Text(
            'Đóng',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () async {
            try {
              EasyLoading.show(status: "Đang xử lí...");
              await medicineController.addMedicineBase();
              medicineController.clearData();
            } catch (e) {
              log(e.toString());
              Get.snackbar("Lỗi", "Có lỗi xảy ra khi thêm thuốc",
                  backgroundColor: Colors.red);
            } finally {
              EasyLoading.dismiss();
            }
          },
          child: Text(
            'Xác nhận',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
