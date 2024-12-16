import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/image_analyze/controller.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';
import 'package:health_for_all/pages/medical_data/widget/add_file.dart';
import 'package:image_picker/image_picker.dart';

class ComboBox extends StatefulWidget {
  final String leadingiconpath;
  final String title;
  final String time;
  final RxString? value;
  final RxString? unit;
  final TextEditingController valueController;
  final TextEditingController unitController;
  final TextEditingController noteController;

  const ComboBox({
    super.key,
    required this.leadingiconpath,
    required this.title,
    this.value,
    this.unit,
    required this.valueController,
    required this.unitController,
    required this.noteController,
    required this.time,
  });

  @override
  _ComboBoxState createState() => _ComboBoxState();
}

class _ComboBoxState extends State<ComboBox> {
  final medicalController = Get.find<MedicalDataController>();
  final appController = Get.find<ApplicationController>();
  final imageAnalyze = Get.find<ImageAnalyzeController>();
  RxBool isLoading = false.obs;
  List<XFile> selectedFiles = [];
  Future updateFiles(List<XFile> newFiles) async {
    if (newFiles.isEmpty) {
      widget.valueController.clear();
      selectedFiles.clear();
      return;
    }
    if (widget.valueController.text.isEmpty && widget.title == 'Huyết áp') {
      imageAnalyze.state.image.value = File(newFiles[0].path);
      isLoading.value = true;
      Future.delayed(Duration.zero, () {
        if (isLoading.value) {
          Get.dialog(const Center(child: CircularProgressIndicator()));
        }
      });
      log('image : ${imageAnalyze.state.image.value}');
      await imageAnalyze.analyzeImage().then((_) {
        widget.valueController.text =
            '${imageAnalyze.state.systolic.value}/${imageAnalyze.state.diastolic.value}';
      }).whenComplete(() {
        Get.back();
        isLoading.value = false;
        Future.delayed(Duration.zero, () {
          setState(() {
            selectedFiles = newFiles;
            for (var i in selectedFiles) {
              log('combobox : ${i.path}');
            }
          });
        });
      });
      medicalController.state.data[widget.title]?.value =
          '${imageAnalyze.state.systolic.value}/${imageAnalyze.state.diastolic.value}';
      log('combobox : ${medicalController.state.data[widget.title]?.value}');
      log('hehe'
          '${imageAnalyze.state.systolic.value}/${imageAnalyze.state.diastolic.value}');
    }
  }

  RxBool ischeck = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: Column(
        children: [
          Obx(() {
            RxBool haveFile = (selectedFiles.isNotEmpty).obs;
            RxBool haveNote = widget.noteController.text.isNotEmpty.obs;
            ischeck.value =
                medicalController.state.data[widget.title]?.value != null && medicalController.state.data[widget.title]?.value != '';
            if (ischeck.value == false) {
              haveFile = false.obs;
              haveNote = false.obs;
            }
            return Container(
              width: double.infinity,
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ischeck.value
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(widget.leadingiconpath),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _buildTextContainer(widget.title, widget.time)),
                  Expanded(child: _buildValueUnitColumn(context)),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: haveNote.value
                          ? Badge(
                              child: Icon(
                                Icons.edit_note, // Icon when files are present
                                color: ischeck.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                              ),
                            )
                          : Icon(
                              Icons.edit_note, // Icon when no files are present
                              color: ischeck.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: haveFile.value
                          ? Badge(
                              child: Icon(
                                Icons
                                    .attach_file, // Icon when files are present
                                color: ischeck.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                              ),
                            )
                          : Icon(
                              Icons
                                  .attach_file, // Icon when no files are present
                              color: ischeck.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (ischeck.value) {
                        selectedFiles.clear();
                        widget.valueController.clear();
                        medicalController.state.data[widget.title]!.value = '';
                        medicalController.state.data[widget.title]!.note = '';
                        medicalController.state.data[widget.title]!.imagePaths =
                            [];
                        medicalController.state.data[widget.title]!.imageUrls =
                            [];
                        medicalController.state.data[widget.title]!.unit = '';
                        ischeck.value = false;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest,
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Icon(
                          Icons.clear,
                          color: ischeck.value
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildTextContainer(String name, String time) {
    return SizedBox(
      height: 76,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              time,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueUnitColumn(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              medicalController.state.data[widget.title]?.value ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              medicalController.state.data[widget.title]?.unit ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 70,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogHeader(),
                  const SizedBox(height: 24),
                  _buildDialogInputFields(),
                  const SizedBox(height: 4),
                  Flexible(
                    child: AddFile(
                      files: selectedFiles,
                      onFilesChanged: updateFiles,
                      medName: widget.title,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDialogActions(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _buildDialogHeader() {
    return Row(
      children: [
        Image.asset(widget.leadingiconpath),
        const SizedBox(width: 10),
        Text(widget.title,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface,
            )),
      ],
    );
  }

  Column _buildDialogInputFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDialogTextField(
                  'Giá trị đo', 'Giá trị', widget.valueController),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildDialogTextField('Đơn vị', '', widget.unitController,
                  readOnly: true),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildDialogTextField('Ghi chú', 'Ghi chú', widget.noteController,
            icon: Icons.edit_note),
      ],
    );
  }

  Widget _buildDialogTextField(
      String label, String hint, TextEditingController controller,
      {IconData? icon, bool? readOnly}) {
    return SizedBox(
      height: 78,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 16,
          ),
          border: const OutlineInputBorder(),
          prefixIcon: icon != null
              ? Icon(icon, color: Theme.of(context).colorScheme.primary)
              : null,
        ),
      ),
    );
  }

  Row _buildDialogActions(BuildContext context) {
    MedicalEntity data = MedicalEntity();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            ischeck.value = false;
            medicalController.clearController();
            Get.back();
          },
          child: Text(
            'Hủy',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () async {
            ischeck.value = true;
            String? typeId = await FirebaseApi.getDocumentId(
                'type_medical_data', 'name', widget.title);
            // List<String> imageUrl = [];

            // for (var i in selectedFiles) {
            //   String? url =
            //       await FirebaseApi.uploadImage(i.path, 'medicalData');
            //   imageUrl.add(url!);
            // }
            // Create MedicalEntity with the obtained typeId
            data = MedicalEntity(
                userId: appController.state.profile.value!.id,
                typeId: typeId,
                time: medicalController.updateTimestamp(),
                value: widget.valueController.text,
                unit: widget.unitController.text,
                note: widget.noteController.text,
                imagePaths: [for (var i in selectedFiles) i.path],
                imageUrls: []);
            medicalController.state.data[widget.title] = data;
            medicalController.state.selectedFile.value = null;
            selectedFiles.clear();
            medicalController.clearController();
            log(medicalController.state.data.toString());
            Get.back();
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
