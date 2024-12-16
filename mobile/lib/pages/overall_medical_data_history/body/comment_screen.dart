import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/comment.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});
  RxBool isExpanded = false.obs;
  final controller = Get.find<OverallMedicalDataHistoryController>();
  void _toggleContainer() {
    isExpanded.value = !isExpanded.value;
  }

  void _delete(BuildContext context, Comment comment) {
    _handleDelete(context, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(() =>
                Text('Bình luận (${controller.state.commmentList.length})'))
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainer),
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: controller.state.commmentList.length,
                itemBuilder: (context, index) {
                  final comment = controller.state.commmentList[index];
                  return FutureBuilder<String>(
                    future: controller.getUser(comment.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final name = snapshot.data ?? 'Unknown';
                        return Column(
                          children: [
                            buildBoxComment(comment, context, name),
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.surfaceDim),
              child: TextField(
                controller: controller.commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none, // Tắt gạch chân
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16), // Thêm padding nếu cần
                ),
              ),
            )),
            IconButton(
                onPressed: () async {
                  await controller.addComment(context);
                  await controller.getAllCommentByMedicalType();
                  controller.commentController.clear();
                },
                icon: Icon(
                  Icons.send,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ))
          ],
        ),
      ],
    );
  }

  Widget buildBoxComment(Comment comment, BuildContext context, String name) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(name),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${DatetimeChange.getHourString(comment.time.toDate())}, ${DatetimeChange.getDatetimeString(comment.time.toDate())}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                      Icon(
                        isExpanded.value
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text('Đã bình luận'),
                      SizedBox(
                        width: 6,
                      ),
                      // const Text("·"),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                    ],
                  ),
                  Text(comment.content),
                  isExpanded.value == true
                      ? SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _delete(context, comment);
                                  log('comment: ${controller.state.commmentList.length}');
                                },
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      (MediaQuery.of(context).size.width - 64) /
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
    });
  }

  Future<void> _handleDelete(BuildContext context, Comment comment) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Perform the delete operation
      FirebaseApi.deleteDocument('comments', comment.id!);

      // Hide loading dialog and show success dialog after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Xóa bình luận thành công'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
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
          content: const Text('Lỗi khi xóa dữ liệu. Hãy thử lại!'),
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
