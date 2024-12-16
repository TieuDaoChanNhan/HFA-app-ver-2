import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/from_doctor.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/view_data_box.dart';
import 'package:health_for_all/pages/diagnostic_detail/widget/doctor_diagnostic.dart';
import 'package:health_for_all/pages/diagnostic_detail/widget/patient_box.dart';
import 'package:path/path.dart' as path;

class DetailView extends StatelessWidget {
  final UserData user;
  final String notification;
  final String doctor;
  final String time;
  final MedicalEntity medicalData;
  List<String>? attachments = [];

  DetailView(
      {super.key,
      required this.user,
      required this.notification,
      required this.doctor,
      required this.time,
      required this.medicalData,
      this.attachments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết chẩn đoán'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      'Chẩn đoán tới',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              PatientBox(user: user),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      'Loại dữ liệu',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        DatetimeChange.getDatetimeString(
                            medicalData.time!.toDate()),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ViewDataBox(
                      leadingiconpath:
                          Item.getIconPath(int.parse(medicalData.typeId!)),
                      title: Item.getTitle(int.parse(medicalData.typeId!)),
                      value: medicalData.value!,
                      unit: Item.getUnit(int.parse(medicalData.typeId!)),
                      note: medicalData.note,
                      time: DatetimeChange.getHourString(
                          medicalData.time!.toDate()),
                      attachments: medicalData.imageUrls,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      'Chẩn đoán',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              DoctorDiagnostic(note: notification),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      'Chẩn đoán',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    buildFileList(context),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FromDoctor(doctorname: doctor)
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFileList(context) {
  //   final DiagnosticAddController diagnosticaddController =
  //       Get.find<DiagnosticAddController>();
  //   if (attachments.isEmpty) {
  //     return DottedBorder(
  //       borderType: BorderType.RRect,
  //       radius: const Radius.circular(4),
  //       dashPattern: const [2, 3],
  //       color: Theme.of(context).colorScheme.outline,
  //       child: Container(
  //         // width: 260,
  //         height: 32,
  //         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
  //         alignment: Alignment.topLeft,
  //         child: Text(
  //           'Không có file đính kèm',
  //           style:
  //               TextStyle(color: Theme.of(context).colorScheme.outlineVariant),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: attachments.length,
  //       itemBuilder: (context, index) {
  //         final Future<XFile?> file =
  //             diagnosticaddController.urlToFile(attachments[index]);
  //         return FutureBuilder<XFile?>(
  //           future: file,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.done) {
  //               if (snapshot.hasData) {
  //                 return _buildFileItem(snapshot.data!, context);
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

  // Widget _buildFileItem(XFile file, BuildContext context) {
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

  Widget buildFileList(BuildContext context) {
    if (attachments!.isEmpty) {
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
      return ListView.builder(
        shrinkWrap: true,
        itemCount: attachments?.length,
        itemBuilder: (context, index) {
          final String file = attachments![index];
          return buildFileItem(file, context);
        },
      );
    }
  }

  Widget buildFileItem(String file, BuildContext context) {
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
