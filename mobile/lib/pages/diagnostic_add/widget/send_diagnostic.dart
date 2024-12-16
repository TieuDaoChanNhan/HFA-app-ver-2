import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/following_medical_data/widget/following_person_box.dart';

class SendDiagnostic extends StatelessWidget {
  const SendDiagnostic({super.key, required this.user});
  final UserData user;
  @override
  Widget build(BuildContext context) {
    final DiagnosticAddController diagnosticAddController =
        Get.find<DiagnosticAddController>();
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 175,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Gửi chẩn đoán tới',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            FollowingPersonBox(
                avapath: user.photourl!,
                name: user.name!,
                gender: user.gender != "" ? user.gender! : "chưa cập nhật",
                age: user.age != 0 ? user.age!.toString() : "chưa cập nhật",
                person: "Bệnh nhân")

            // for (int i = 0; i < listuser.length; i++)
            //   GestureDetector(
            //     onTap: () {},
            //     child: Obx(
            //       () => FollowingPersonBox(
            //         avapath: listuser[i].photourl!,
            //         name: listuser[i].name!,
            //         gender: listuser[i].gender != ""
            //             ? listuser[i].gender!
            //             : "chưa cập nhật",
            //         age: listuser[i].age != 0
            //             ? listuser[i].age!.toString()
            //             : "chưa cập nhật",
            //         person: "Bệnh nhân",
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  // Future<void> build_popup_user(context) async {
  //   final DiagnosticAddController diagnosticAddController =
  //       Get.put(DiagnosticAddController());
  //   final result = await showDialog<UserData>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           children: [
  //             Icon(
  //               Icons.tune,
  //               color: Theme.of(context).primaryColor,
  //               size: 32,
  //             ),
  //             const SizedBox(
  //               width: 16,
  //             ),
  //             Text(
  //               "Gửi chẩn đoán tới",
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 color: Theme.of(context).colorScheme.onSurface,
  //               ),
  //             ),
  //           ],
  //         ),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: 10),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             for (int i = 0; i < listuser.length; i++)
  //               ListTile(
  //                 title: Obx(
  //                   () => FollowingPersonBox(
  //                     avapath: listuser[i].photourl!,
  //                     name: listuser[i].name!,
  //                     gender: listuser[i].gender != ""
  //                         ? listuser[i].gender!
  //                         : "chưa cập nhật",
  //                     age: listuser[i].age != 0
  //                         ? listuser[i].age!.toString()
  //                         : "chưa cập nhật",
  //                     person: "Bệnh nhân",
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   Navigator.pop(context, listuser[i]);
  //                 },
  //               ),
  //           ],
  //         ),
  //       );
  //     },
  //   );

  //   if (result != null) {
  //     diagnosticAddController.chosenuser.value = result;
  //     print(110);
  //   }
  // }
}
