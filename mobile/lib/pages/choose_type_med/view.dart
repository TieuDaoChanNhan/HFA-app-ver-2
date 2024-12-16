
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/pages/choose_type_med/widget/add_typed_med.dart';
import 'package:health_for_all/pages/choose_type_med/widget/edit_typed_med.dart';

import 'controller.dart';

class ChooseTypeMed extends StatefulWidget {
  const ChooseTypeMed({super.key});

  @override
  State<ChooseTypeMed> createState() => _ChooseTypeMedState();
}

class _ChooseTypeMedState extends State<ChooseTypeMed> {
  final medicineController = Get.find<ChooseTypeMedController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chọn loại thuốc",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          Icon(
            Icons.help_outline,
            size: 24,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        add_type_med(),
                        const SizedBox(
                          height: 16,
                        ),
                        head_list(),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('medicineBases')
                        .where('userId', isEqualTo: medicineController.state.profile.value?.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Có lỗi xảy ra');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final data = snapshot.data!.docs
                          .map((doc) => MedicineBase.fromFirestore(
                              doc as DocumentSnapshot<Map<String, dynamic>>))
                          .toList();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        medicineController.state.medicineCount.value =
                            data.length;
                      });
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final doc = data[index];
                          return type_med(index, doc);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: OutlinedButton(
          //     onPressed: () {},
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width - 81,
          //       child: Center(
          //         child: Text(
          //           "Xem thêm 0 loại thuốc",
          //           style: TextStyle(
          //             color: Theme.of(context).colorScheme.primary,
          //             fontSize: 14,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  medicineController.state.selectedMedicineIndex.clear();
                  medicineController.state.selectedMedicineBases.clear();
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 75,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Center(
                    child: Text(
                      "Hủy",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 75,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Center(
                    child: Text(
                      "Xác nhận",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget head_list() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Obx(() => Text(
                    "Danh sách thuốc (${medicineController.state.medicineCount.value})",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ))
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }

  Widget type_med(int index, MedicineBase medicine) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Obx(
                  () => Checkbox(
                      value: medicineController.state.selectedMedicineIndex
                          .contains(index),
                      onChanged: (newBool) {
                        if (newBool!) {
                          medicineController.state.selectedMedicineIndex
                              .add(index);
                          medicineController.state.selectedMedicineBases
                              .add(medicine);
                        } else {
                          medicineController.state.selectedMedicineIndex
                              .remove(index);
                          medicineController.state.selectedMedicineBases
                              .remove(medicine);
                        }
                      }),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  medicine.name ?? "",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showDialog(context, const EditTypedMed());
            },
            child: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // SizedBox(width: 6,),
          // GestureDetector(
          //   onTap: () {
          //     medicineController.delMedicineBase(medicine.id!);
          //   },
          //   child: Icon(
          //     Icons.clear_outlined,
          //     color: Theme.of(context).colorScheme.error,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget add_type_med() {
    return GestureDetector(
      onTap: () {
        _showDialog(context, const AddTypedMed());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
              // offset: Offset(0, 3), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Thêm mới loại thuốc",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, Widget next) {
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
                  Flexible(child: next),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
