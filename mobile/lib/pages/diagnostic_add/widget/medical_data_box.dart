import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';

class MedicalDataBox extends StatefulWidget {
  final String leadingiconpath;
  final String title;
  final String time;
  final RxString? value; // Changed to RxString
  final RxString? unit; // Changed to RxString
  final TextEditingController valueController;
  final TextEditingController unitController;
  final TextEditingController noteController;

  const MedicalDataBox({
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
  State<MedicalDataBox> createState() => MedicalDataBoxState();
}

class MedicalDataBoxState extends State<MedicalDataBox> {
  final medicalController = Get.find<MedicalDataController>();
  List<XFile> selectedFiles = [];
  void updateFiles(List<XFile> newFiles) {
    setState(() {
      selectedFiles = newFiles;
      for (var i in selectedFiles) {
        log('combobox : ${i.path}');
      }
    });
  }

  RxBool ischeck = false.obs;

  @override
  Widget build(BuildContext context) {
    bool haveFile = (selectedFiles.isNotEmpty);
    bool haveNote = widget.noteController.text.isNotEmpty;
    return Container(
      width: double.infinity,
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(widget.leadingiconpath),
          const SizedBox(width: 8),
          Expanded(child: _buildTextContainer(widget.title, widget.time)),
          Expanded(child: _buildValueUnitColumn(context)),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: haveNote
                    ? Badge(
                        child: Icon(
                          Icons.edit_note, // Icon when files are present
                          color: ischeck.value
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      )
                    : Obx(
                        () => Icon(
                          Icons.edit_note, // Icon when no files are present
                          color: ischeck.value
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      )),
          ),
          const SizedBox(width: 8),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: haveFile
                    ? Badge(
                        child: Icon(
                          Icons.attach_file, // Icon when files are present
                          color: ischeck.value
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      )
                    : Icon(
                        Icons.attach_file, // Icon when no files are present
                        color: ischeck.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: Obx(
                  () => Icon(
                    Icons.clear,
                    color: ischeck.value
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                )),
          ),
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
    return SizedBox(
        height: 55,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  medicalController.state.data[widget.title]?.value ?? "",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  medicalController.state.data[widget.title]?.unit ?? "",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
