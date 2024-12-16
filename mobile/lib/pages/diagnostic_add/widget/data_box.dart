import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/information.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';
import 'package:image_picker/image_picker.dart';

class DataBox extends StatefulWidget {
  final String leadingiconpath;
  final String title;
  final String time;
  final String value;
  final String unit;
  final TextEditingController noteController;
  final int pos;

  const DataBox({
    super.key,
    required this.leadingiconpath,
    required this.title,
    required this.value,
    required this.unit,
    required this.noteController,
    required this.time,
    required this.pos,
  });

  @override
  State<DataBox> createState() => _DataBoxState();
}

class _DataBoxState extends State<DataBox> {
  final medicalController = Get.find<MedicalDataController>();
  final appController = Get.find<ApplicationController>();
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
    return Obx(
      () => GestureDetector(
        onTap: () {
          ischeck.value = !ischeck.value;
          tapped[widget.pos].value = !tapped[widget.pos].value;
          if (ischeck.value == true) {
            view.add(ind[widget.pos]);
          } else {
            view.remove(ind[widget.pos]);
          }
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 71,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(
                color: ischeck.value
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Image.asset(widget.leadingiconpath),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _buildTextContainer(widget.title, widget.time)),
                  Expanded(child: _buildValueUnitColumn(context)),
                  // const SizedBox(width: 8),
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
                      child: haveNote
                          ? Badge(
                              child: Icon(
                                Icons.edit_note, // Icon when files are present
                                color: ischeck.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                size: 16,
                              ),
                            )
                          : Icon(
                              Icons.edit_note, // Icon when no files are present
                              color: ischeck.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              size: 16,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Container(
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
                        child: haveFile
                            ? Badge(
                                child: Icon(
                                  Icons
                                      .attach_file, // Icon when files are present
                                  color: ischeck.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                  size: 16,
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
                                size: 16,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      selectedFiles.clear();
                      ischeck.value = false;
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
                          child: Obx(
                            () => Icon(
                              Icons.clear,
                              color: ischeck.value
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              size: 16,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        ),
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
                fontSize: 14,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 14,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.unit,
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
}
