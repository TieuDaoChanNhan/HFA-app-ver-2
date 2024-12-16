import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/notification_entity.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/enum/type_notification_status.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/alarm/view.dart';
import 'package:health_for_all/pages/diagnostic/view.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:health_for_all/pages/profile/view.dart';

class NotificationItem extends StatelessWidget {
  NotificationItem(
      {super.key,
      required this.name,
      required this.isExpanded,
      required this.status,
      required this.notification});
  final String name;
  late RxBool isExpanded;
  final TypeNotificationStatus status;
  final NotificationEntity notification;
  final controller = Get.find<NotificationController>();

  void _toggleContainer() {
    isExpanded.value = !isExpanded.value;
    // isExpanded = true;
  }

  void setread(BuildContext context) {
    if (status.value != 'read') {
      _handleupdate(context, {'status': 'read'});
      // _handleDelete(context);
      // _handlemoveread(context);
    }
  }

  void delete(BuildContext context) {
    _handleDelete(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Obx(
      () => GestureDetector(
        onTap: () {
          _toggleContainer();
        },
        child: IntrinsicHeight(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      child: Row(
                    children: [
                      Icon(
                        Icons.person_add_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('•',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          )),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(name,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          )),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('•',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          )),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                          DatetimeChange.timestampToString(
                              notification.time as Timestamp),
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          )),
                    ],
                  )),
                  Icon(
                    isExpanded.value
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: Theme.of(context).colorScheme.outline,
                    size: 16,
                  ),
                ]),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  notification.title!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                  ),
                  softWrap: true,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  notification.body!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                  ),
                  softWrap: true,
                ),
                isExpanded.value == true
                    ? Row(
                        children: [
                          FutureBuilder<UserData>(
                            future: controller.getUser(notification.toUId!),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              } else {
                                final docs = userSnapshot.data ?? UserData();
                                return GestureDetector(
                                  onTap: () {
                                    if (notification.page! == '/diagnotic') {
                                      Get.to(() => DiagnosticPage(
                                            user: docs,
                                          ));
                                    }
                                    if (notification.page! == 'follow') {
                                      Get.to(() => const ProfilePage());
                                    }
                                    if (notification.page! == '/alarm') {
                                      Get.to(() => AlarmPage(controller.state.profile.value!, true));
                                    }
                                    print('User want to see detail');
                                  },
                                  child: SizedBox(
                                    height: 32,
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
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
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 40,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
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
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setread(context);
                              print('User tapped at Read');
                            },
                            child: SizedBox(
                              height: 32,
                              width:
                                  (MediaQuery.of(context).size.width - 64) / 3,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Đã đọc',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
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
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              delete(context);
                              print('User tapped at Delete');
                            },
                            child: SizedBox(
                              height: 32,
                              width:
                                  (MediaQuery.of(context).size.width - 64) / 3,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Xóa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
      FirebaseApi.updateDocument('notifications', notification.id!, data);
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
    } finally {
      EasyLoading.dismiss();
    }
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
      FirebaseApi.deleteDocument('notifications', notification.id!);

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
    } finally {
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
