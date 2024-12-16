import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';
import 'package:path/path.dart' as path;

class ViewDataBox extends StatelessWidget {
  final String leadingiconpath;
  final String title;
  final String time;
  final String value;
  final String unit;
  String? note;
  List<String>? attachments = [];

  ViewDataBox({
    super.key,
    required this.leadingiconpath,
    required this.title,
    required this.value,
    required this.unit,
    this.note,
    required this.time,
    this.attachments,
  });
  final diagnosticaddController = Get.find<DiagnosticAddController>();
  final medicalController = Get.find<MedicalDataController>();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    bool haveFile = attachments != null && attachments!.isNotEmpty;
    bool haveNote = note != null && note!.isNotEmpty;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 71,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Image.asset(leadingiconpath),
              const SizedBox(width: 8),
              Expanded(child: _buildTextContainer(context, title, time)),
              Expanded(child: _buildValueUnitColumn(context)),
              // const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  shownotepopup(context);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: haveNote
                        ? Badge(
                            child: Icon(
                              Icons.edit_note, // Icon when files are present
                              color: haveNote
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              size: 18,
                            ),
                          )
                        : Icon(
                            Icons.edit_note, // Icon when no files are present
                            color: haveNote
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            size: 18,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  showfilepopup(context);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: haveFile
                        ? Badge(
                            child: Icon(
                              Icons.attach_file, // Icon when files are present
                              color: haveFile
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              size: 18,
                            ),
                          )
                        : Icon(
                            Icons.attach_file, // Icon when no files are present
                            color: haveFile
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            size: 18,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTextContainer(context, String name, String time) {
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueUnitColumn(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 22,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              unit,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void shownotepopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Ghi chú của người dùng',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                ],
              ),
              content: IntrinsicHeight(
                child: TextField(
                  readOnly: true,
                  // maxLines: 3,
                  decoration: InputDecoration(
                    // prefixText: note,
                    border: const OutlineInputBorder(),
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_note,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  controller: TextEditingController(text: note),
                ),
              ));
        });
  }

  void showfilepopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                'File đính kèm',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildFileList(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFileList(BuildContext context) {
    if (attachments == null || attachments!.isEmpty) {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(4),
        dashPattern: const [2, 3],
        color: Theme.of(context).colorScheme.outline,
        child: Container(
          // width: 260,
          height: 32,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          alignment: Alignment.topLeft,
          child: Text(
            'Không có file đính kèm',
            style:
                TextStyle(color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
      );
    } else {
      log('start to build list');
      return Column(
        children: [
          for (int i = 0; i < attachments!.length; i++)
            buildFileItem(attachments![i], context),
        ],
      );
    }
  }

  Widget buildFileItem(String file, BuildContext context) {
    log('start to build file');
    final String fileName = path.basename(file);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(file),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  fileName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFileList(context) {
  //   if (selectedFiles!.isEmpty) {
  //     return DottedBorder(
  //       borderType: BorderType.RRect,
  //       radius: const Radius.circular(4),
  //       dashPattern: const [2, 3],
  //       color: Theme.of(context).colorScheme.outline,
  //       child: Container(
  //         height: 32,
  //         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
  //         alignment: Alignment.topLeft,
  //         child: Text(
  //           'Không có file đính kèm',
  //           style: TextStyle(color: Theme.of(context).colorScheme.outline),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: selectedFiles!.length,
  //       itemBuilder: (context, index) {
  //         final Future<XFile?> file =
  //             diagnosticaddController.urlToFile(selectedFiles![index]);
  //         return FutureBuilder<XFile?>(
  //           future: file,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.done) {
  //               if (snapshot.hasData) {
  //                 return _buildFileItem(context, snapshot.data!);
  //               } else {
  //                 return Text('Failed to load file');
  //               }
  //             } else {
  //               return CircularProgressIndicator();
  //             }
  //           },
  //         );
  //       },
  //     );
  //   }
  // }

  // Widget _buildFileItem(context, XFile file) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: Theme.of(context).colorScheme.primaryContainer,
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             _getFileIcon(file),
  //             color: Theme.of(context).colorScheme.primary,
  //           ),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: Text(
  //               file.name,
  //               style: TextStyle(
  //                 color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // IconData _getFileIcon(XFile file) {
  //   final String extension = file.name.split('.').last;
  //   switch (extension.toLowerCase()) {
  //     case 'jpg':
  //     case 'jpeg':
  //     case 'png':
  //     case 'gif':
  //       return Icons.image;
  //     case 'mp4':
  //     case 'avi':
  //     case 'mov':
  //       return Icons.video_file;
  //     case 'pdf':
  //       return Icons.picture_as_pdf;
  //     default:
  //       return Icons.insert_drive_file;
  //   }
  // }
}
