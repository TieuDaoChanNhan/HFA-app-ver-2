import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health_for_all/common/entities/comment.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/overall_medical_data_history/body/alert_screen.dart';
import 'package:health_for_all/pages/overall_medical_data_history/body/comment_screen.dart';
import 'package:health_for_all/pages/overall_medical_data_history/body/detail_screen.dart';
import 'package:health_for_all/pages/overall_medical_data_history/body/diagnostic.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/overall_medical_data_history/state.dart';
import 'package:health_for_all/pages/overall_medical_data_history/widget/combo_box.dart';

class OverallMedicalDataHistoryController extends GetxController {
  final state = OverrallMedicalDataHistoryState();
  final appController = Get.find<ApplicationController>();
  final commentController = TextEditingController();
  DateTime datetime = DateTime.now();
  RxString dateSelected = "".obs;
  Rx<DateTime> dateTimeSelected = DateTime.now().obs;
  RxMap<String, MedicalEntity> listEveryData = <String, MedicalEntity>{}.obs;
  static int length = 10;
  void updateLength() {
    length++;
  }

  RxList<UserData> listFollower = <UserData>[].obs;

  void fetchData(List<String> id) async {
    listFollower.clear();
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Call getData and await the result
      listFollower = await getData(id);
      print(listFollower.length);
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<RxList<UserData>> getData(List<String> id) async {
    RxList<UserData> users = <UserData>[].obs;
    final db = FirebaseFirestore.instance;

    for (String userId in id) {
      final querySnapshot =
          await db.collection("users").where('id', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = await querySnapshot.docs.first.reference.get();
        final userData = UserData.fromFirestore(docSnapshot, null);
        users.add(userData);
      }
    }
    return users;
  }

  Future addComment(BuildContext context) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final comment = Comment(
          uid: appController.state.profile.value!.id!,
          content: commentController.text,
          time: Timestamp.fromDate(DateTime.now()),
          medicalId: state.medicalId.value);
      log(comment.toString());
      await FirebaseApi.addDocument('comments', comment.toFirestore());
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: Text('Lỗi thêm bình luận: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future getAllCommentByMedicalType() async {
    state.commmentList.clear();
    final snapshot = await FirebaseApi.getQuerySnapshot(
        'comments', 'medicalId', state.medicalId.value);
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final comment = Comment.fromFirestore(doc);
        state.commmentList.add(comment);
      }
    }
  }

  Future<String> getUser(String userId) async {
    final db = FirebaseFirestore.instance;
    final querySnapshot =
        await db.collection("users").where('id', isEqualTo: userId).get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = await querySnapshot.docs.first.reference.get();
      final userData = UserData.fromFirestore(docSnapshot, null);
      return userData.name!;
    }
    return '';
  }

  Future getEntries(BuildContext context) async {
    final futures = List.generate(length, (index) async {
      final MedicalEntity? data = await fetchLatestEventInDay(
          dateTimeSelected.value, Item.getTitle(index), 1);
      return GestureDetector(
        onTap: () {
          print(data.toString());
          if (data != null) {
            state.medicalId.value = data.id!;
            state.selectedData.value = data;
            getAllCommentByMedicalType();
            log(state.medicalId.value);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  // insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                  insetPadding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  content: SizedBox(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(28),
                    //     ),
                    // padding: EdgeInsets.
                    width: MediaQuery.of(context).size.width,
                    child: DefaultTabController(
                      length: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              Image.asset(Item.getIconPath(index)),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                Item.getTitle(index),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                ('${DatetimeChange.getHourString(data.time!.toDate())}, ${DatetimeChange.getDatetimeString(data.time!.toDate())}'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                              ),
                              Text(data.value ?? "--",
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer)),
                              Text(Item.getUnit(index),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                DetailScreen(
                                  note: data.note ?? "",
                                  images: data.imageUrls ?? [],
                                ),
                                CommentScreen(),
                                DiagnosticScreen(),
                                AlertScreen(),
                              ],
                            ),
                          ),
                          const TabBar(
                            labelPadding: EdgeInsets.symmetric(horizontal: 1),
                            tabs: [
                              Tab(text: 'Chi tiết'),
                              Tab(text: 'Bình luận'),
                              Tab(text: 'Chẩn đoán'),
                              Tab(text: 'Cảnh báo'),
                            ],
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Huỷ')),
                              // TextButton(
                              //     onPressed: () {}, child: const Text('Sửa'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Không có dữ liệu'),
                  content:
                      const Text('Không có dữ liệu bạn đã chọn trong ngày này'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Column(
          children: [
            ComboBox(
              leadingiconpath: Item.getIconPath(index),
              title: Item.getTitle(index),
              value: data?.value ?? '--',
              unit: Item.getUnit(index),
              time: data != null
                  ? DatetimeChange.getHourString(data.time!.toDate())
                  : '--',
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      );
    });

    return await Future.wait(futures);
  }

  @override
  void onInit() {
    super.onInit();
    dateSelected.value = DateFormat('dd/MM/yyyy').format(DateTime.now());
    log(dateSelected.value);
    // fetchEventsInDay(DateTime(2024, 8, 14), 'Huyết áp', 1);
  }

  @override
  void onReady() async {
    super.onReady();
    await fetchLastEventEveryData();

    ever(dateTimeSelected, (_) async {
      dateSelected.value =
          DateFormat('dd/MM/yyyy').format(dateTimeSelected.value);
    });

    ever(dateSelected, (_) {});
    // ever(state.selectedUserId, (_) async {
    //   await getUserData();
    // });
  }

  Future fetchLastEventEveryData() async {
    for (int i = 0; i <= 9; i++) {
      final data = await fetchLatestEvent(DateTime.now(), i.toString());
      if (data != null) {
        listEveryData[Item.getTitle(i)] = data;
      }
    }
    for (var i in listEveryData.keys) {
      log(i);
    }
    for (var i in listEveryData.values) {
      log(i.toString());
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          dateTimeSelected.value, // Dùng dateTimeSelected thay vì datetime
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      datetime = selectedDate;
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      dateSelected.value = formattedDate;
      dateTimeSelected.value = selectedDate;
      await getEntries(context);
    }
  }

  Future<MedicalEntity?> fetchLatestEvent(DateTime date, String typeId) async {
    final db = FirebaseFirestore.instance;

    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Chuyển đổi DateTime thành Timestamp
      final time = Timestamp.fromDate(date);

      // Tìm tài liệu từ collection 'medicalData' với typeId và userId
      // Và lọc theo thời gian trong ngày
      final querySnapshot = await db
          .collection('medicalData')
          .where('typeId', isEqualTo: typeId)
          .where('userId',
              isEqualTo: appController.state.selectedUserId.value != ""
                  ? appController.state.selectedUserId.value
                  : appController.state.profile.value
                      ?.id) // Lọc tài liệu với 'time' >= startOfDay
          .where('time',
              isLessThanOrEqualTo: time) // Lọc tài liệu với 'time' <= endOfDay
          .orderBy('time', descending: true) // Sắp xếp theo 'time' giảm dần
          .limit(1) // Giới hạn kết quả để lấy tài liệu muộn nhất trong ngày
          .get();
      final documents = querySnapshot.docs;
      if (documents.isEmpty) {
        // Không tìm thấy tài liệu phù hợp trong ngày
        return null;
      }
      log(documents.first.toString());
      // Chuyển đổi dữ liệu tài liệu thành đối tượng MedicalEntity
      final data = MedicalEntity.fromFirestore(documents.first, null);
      log(data.toString());
      return data;
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching latest event in day $date: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<MedicalEntity?> fetchLatestEventInDay(
      DateTime date, String value, int? limit) async {
    final db = FirebaseFirestore.instance;

    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Xác định khoảng thời gian của ngày
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      // Chuyển đổi DateTime thành Timestamp
      final startTimestamp = Timestamp.fromDate(startOfDay);
      final endTimestamp = Timestamp.fromDate(endOfDay);

      // Lấy typeId từ Firestore bằng giá trị trường 'name'
      final query = await FirebaseApi.getQuerySnapshot(
          'type_medical_data', 'name', value);
      final docs = query.docs;
      if (docs.isEmpty) {
        // Không tìm thấy tài liệu với 'name' là specificValue
        return null;
      }

      final typeId = docs.first.id;
      // Tìm tài liệu từ collection 'medicalData' với typeId và userId
      // Và lọc theo thời gian trong ngày
      final querySnapshot = await db
          .collection('medicalData')
          .where('typeId', isEqualTo: typeId)
          .where('userId',
              isEqualTo: appController.state.selectedUserId.value != ""
                  ? appController.state.selectedUserId.value
                  : appController.state.profile.value?.id)
          .where('time',
              isGreaterThanOrEqualTo:
                  startTimestamp) // Lọc tài liệu với 'time' >= startOfDay
          .where('time',
              isLessThanOrEqualTo:
                  endTimestamp) // Lọc tài liệu với 'time' <= endOfDay
          .orderBy('time', descending: true) // Sắp xếp theo 'time' giảm dần
          .limit(limit ??
              1) // Giới hạn kết quả để lấy tài liệu muộn nhất trong ngày
          .get();
      final documents = querySnapshot.docs;
      if (documents.isEmpty) {
        // Không tìm thấy tài liệu phù hợp trong ngày
        return null;
      }
      log(documents.first.toString());
      // Chuyển đổi dữ liệu tài liệu thành đối tượng MedicalEntity
      final data = MedicalEntity.fromFirestore(documents.first, null);
      log(data.toString());
      return data;
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching latest event in day $date: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future fetchEventsInDay(DateTime date, String value, int? limit) async {
    final db = FirebaseFirestore.instance;
    final List<MedicalEntity> data = [];
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Xác định khoảng thời gian của ngày
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      // Chuyển đổi DateTime thành Timestamp
      final startTimestamp = Timestamp.fromDate(startOfDay);
      final endTimestamp = Timestamp.fromDate(endOfDay);

      // Lấy typeId từ Firestore bằng giá trị trường 'name'
      final query = await FirebaseApi.getQuerySnapshot(
          'type_medical_data', 'name', value);
      final docs = query.docs;

      if (docs.isEmpty) {
        // Không tìm thấy tài liệu với 'name' là specificValue
        return null;
      }

      final typeId = docs.first.id;

      // Tìm tài liệu từ collection 'medicalData' với typeId và userId
      // Và lọc theo thời gian trong ngày
      final querySnapshot = await db
          .collection('medicalData')
          .where('typeId', isEqualTo: typeId)
          .where('userId',
              isEqualTo: appController.state.selectedUserId.value != ""
                  ? appController.state.selectedUserId.value
                  : appController.state.profile.value?.id)
          .where('time',
              isGreaterThanOrEqualTo:
                  startTimestamp) // Lọc tài liệu với 'time' >= startOfDay
          .where('time',
              isLessThanOrEqualTo:
                  endTimestamp) // Lọc tài liệu với 'time' <= endOfDay
          .orderBy('time', descending: true) // Sắp xếp theo 'time' giảm dần
          .limit(limit ??
              1) // Giới hạn kết quả để lấy tài liệu muộn nhất trong ngày
          .get();

      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        // Không tìm thấy tài liệu phù hợp trong ngày
        return null;
      }

      // Chuyển đổi dữ liệu tài liệu thành đối tượng MedicalEntity
      for (final doc in documents) {
        data.add(MedicalEntity.fromFirestore(doc, null));
      }
      state.history[DatetimeChange.getDMYTime(date)] = data;
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching event in day: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future fetchEventAmountTime(
      DateTime start, DateTime end, String value) async {
    for (int i = 0; i < DatetimeChange.getDuration(start, end); i++) {
      await fetchEventsInDay(start, value, 5);
      start = start.add(const Duration(days: 1));
    }
  }
}
