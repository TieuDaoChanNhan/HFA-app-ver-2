import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/pages/prescription/controller.dart';
import 'package:health_for_all/pages/prescription/index.dart';
import 'package:health_for_all/pages/prescription/widget/add_prescription.dart';
import 'package:health_for_all/pages/prescription/widget/filter_sheet.dart';
import 'package:health_for_all/pages/prescription/widget/precription_box.dart';

class PrescriptionPage extends GetView<PrescriptionController> {
  final String userId;
  final bool right;
  const PrescriptionPage(this.userId, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn thuốc'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1.2),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  add_prescrition(context),
                  const SizedBox(height: 16),
                  filter_prescription(
                      context), // This will now update in real-time
                  const Divider(height: 1.2),
                  const SizedBox(height: 16),
                  list_prescription(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget add_prescrition(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (right == false) {
          Get.snackbar("Không có quyền", "Bạn không phải bác sĩ",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        } else {
          _showDialog(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.errorContainer,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Thêm mới đơn thuốc",
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This function listens for changes and updates num_prescription automatically
  Widget filter_prescription(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('prescriptions')
          .where('patientId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Có lỗi xảy ra');
        }

        // Update the prescription count dynamically
        controller.state.num_prescription.value = snapshot.data!.docs.length;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => Text(
                      "Danh sách đơn thuốc (${controller.state.num_prescription})",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    )),
              ),
              IconButton(
                onPressed: () {
                  bottom_sheet(context);
                },
                icon: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  Widget list_prescription() {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('prescriptions')
              .where('patientId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Có lỗi xảy ra');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final data = snapshot.data!.docs
                .map((doc) => Prescription.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>))
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                return FutureBuilder(
                  future: controller.getData(doc.medicalIDs!),
                  builder: (context, medicineSnapshot) {
                    if (medicineSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (medicineSnapshot.hasError) {
                      return const Text('Có lỗi xảy ra khi lấy dữ liệu thuốc');
                    }
                    if (!medicineSnapshot.hasData ||
                        medicineSnapshot.data!.isEmpty) {
                      return const Text('Không có dữ liệu thuốc');
                    }

                    final medicineBases = medicineSnapshot.data!;
                    return PrescriptionBox(
                        detail: doc, med: medicineBases, order: index + 1);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  void bottom_sheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      context: context,
      builder: (ctx) => const FilterSheet(),
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
                  Flexible(
                      child: AddPrescription(
                    userId: userId,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
