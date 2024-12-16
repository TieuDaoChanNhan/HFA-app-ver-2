import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';
import 'package:health_for_all/pages/diagnostic_detail/view.dart';

class animatedcontainer extends StatelessWidget {
  final String doctor;
  final String time;
  final MedicalEntity med;
  final String notification;
  late RxBool isimportance;
  final List<String> attachments;
  final UserData user;
  late RxBool isExpanded;
  final String documentId;
  final String status;
  final diagnosticController = Get.find<DiagnosticAddController>();

  animatedcontainer({
    super.key,
    required this.doctor,
    required this.time,
    required this.notification,
    required this.isimportance,
    required this.attachments,
    required this.isExpanded,
    required this.med,
    required this.user,
    required this.documentId,
    required this.status,
  });

  void _setimportance(BuildContext context) {
    if (status != 'importance') {
      isimportance.value = !isimportance.value;
      _handleupdate(context, {'status': 'importance'});
    } else {
      isimportance.value = !isimportance.value;
      _handleupdate(context, {'status': 'read'});
    }
  }

  void _delete(BuildContext context) {
    _handleDelete(context);
  }

  // void setread(BuildContext context) {
  //   if (status != 'read') {
  //     _handleupdate(context, {'status': 'read'});
  //   }
  // }

  void _toggleContainer() {
    isExpanded.value = !isExpanded.value;
  }

  @override
  Widget build(BuildContext context) {
    bool isAttached = attachments.isNotEmpty;
    return Obx(
      () => GestureDetector(
        onTap: () {
          _toggleContainer();
        },
        child: IntrinsicHeight(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          doctor,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.star,
                          color: isimportance.value
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                          size: 16,
                        ),
                      ],
                    ),
                    Icon(
                      isExpanded.value
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Đã gửi chẩn đoán',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      Item.getTitle(int.parse(med.typeId!)),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${med.value} ${Item.getUnit(int.parse(med.typeId!))}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                isExpanded.value == true
                    ? SizedBox(
                        child: Column(
                          children: [
                            Text(
                              notification,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isAttached)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file_outlined,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Đính kèm (${attachments.length})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => DetailView(
                                        user: user,
                                        notification: notification,
                                        doctor: doctor,
                                        time: time,
                                        medicalData: med,
                                        attachments: attachments));
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Chi tiết',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      26, // Adjust the height to match your row's height
                                  child: VerticalDivider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    thickness: 1,
                                    width: 0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    log('onstatus');
                                    _setimportance(context);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isimportance.value
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Quan trọng',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      26, // Adjust the height to match your row's height
                                  child: VerticalDivider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    thickness: 1,
                                    width: 0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _delete(context);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Xóa',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'thêm ...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Perform the delete operation
      FirebaseApi.deleteDocument('diagnostic', documentId);

      // Hide loading dialog and show success dialog after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Xóa chẩn đoán thành công'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close success dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle any errors
      log('Error deleting data: $e');
      _showErrorDialog(context);
    }
    finally{
      EasyLoading.dismiss();
    }
  }

  Future<void> _handleupdate(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Perform the delete operation
      FirebaseApi.updateDocument('diagnostic', documentId, data);
      // Hide loading dialog and show success dialog after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Chuyển thành công'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close success dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle any errors
      log('Error deleting data: $e');
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
          content: const Text('Lỗi khi chuyển dữ liệu. Hãy thử lại!'),
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
