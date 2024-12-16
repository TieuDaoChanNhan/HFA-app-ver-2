import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/view_data_box.dart';

class TypeOfData extends GetView<DiagnosticAddController> {
  final MedicalEntity medicalData;

  const TypeOfData({super.key, required this.medicalData});
  @override
  Widget build(BuildContext context) {
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
                          'Loại dữ liệu',
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
            Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1),
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8))),
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

                  // for(int i=0; i<tapped.length; i++){
                  //   if(tapped[i].value == true){
                  //     DataBox(
                  //     time: formatTimeOfDay(),
                  //     noteController: noteController,
                  //     leadingiconpath: Item.getIconPath(ind[i]),
                  //     title: Item.getTitle(ind[i]),
                  //     value: Item.getUnit(ind[i]),
                  //     unit: Item.getUnit(ind[i]),
                  //     pos: i,
                  //     ),
                  //   }
                  // }
                  // ListBody(
                  //   mainAxis: Axis.vertical,
                  //   children: [
                  //     MedicalDataBox(leadingiconpath: leadingiconpath, title: title, valueController: valueController, unitController: unitController, noteController: noteController, time: time, pos: pos)
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> showPopup(BuildContext context) async {
  //   final result = await showDialog<List<MedicalEntity>>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return AlertDialog(
  //           title: buildpopupHeader(context),
  //           content: buildpopupCenter(context),
  //         );
  //       });
  //       // Dialog(
  //       //   shape: RoundedRectangleBorder(
  //       //     borderRadius: BorderRadius.circular(28),
  //       //   ),
  //       //   child: SingleChildScrollView(
  //       //     child: Padding(
  //       //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
  //       //       child: Column(
  //       //         mainAxisSize: MainAxisSize.min,
  //       //         children: [
  //       //           buildpopupHeader(context),
  //       //           const SizedBox(height: 24),
  //       //           buildpopupCenter(context),
  //       //           const SizedBox(height: 24),
  //       //           buildpopupActions(context),
  //       //         ],
  //       //       ),
  //       //     ),
  //       //   ),
  //       // );
  //     },
  //   );
  // }

  // Row buildpopupHeader(BuildContext context) {
  //   return Row(
  //     children: [
  //       Icon(
  //         Icons.tune,
  //         size: 32,
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //       const SizedBox(
  //         width: 16,
  //       ),
  //       Text(
  //         'Chọn loại dữ liệu',
  //         style: TextStyle(
  //           fontSize: 24,
  //           color: Theme.of(context).colorScheme.onSurface,
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Row buildpopupActions(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       TextButton(
  //         onPressed: () async {
  //           view.clear();
  //           for (int i = 0; i < tapped.length; i++) {
  //             tapped[i].value = false;
  //           } // showpatient = -1;
  //           Get.back();
  //         },
  //         child: Text(
  //           'Hủy',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Theme.of(context).colorScheme.error,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 16),
  //       TextButton(
  //         onPressed: () async {
  //           // List<String> imageUrl = [];

  //           // for (var i in selectedFiles) {
  //           //   String? url =
  //           //       await FirebaseApi.uploadImage(i.path, 'medicalData');
  //           //   imageUrl.add(url!);
  //           // }
  //           // Create MedicalEntity with the obtained typeId
  //           Get.back();
  //         },
  //         child: Text(
  //           'Xác nhận',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Theme.of(context).colorScheme.primary,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // SingleChildScrollView buildpopupCenter(BuildContext context) {
  //   final DiagnosticAddController diagnosticAddController =
  //       Get.put(DiagnosticAddController());
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         Flex(direction: Axis.horizontal, children: [
  //           Expanded(
  //             flex: 3,
  //             child: _buildDateTimeField(context, 'Ngày', Icons.event_note,
  //                 controller.selectDate, controller.dateController),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: _buildDateTimeField(context, 'Thời gian', Icons.schedule,
  //                 controller.selectTime, controller.timeController),
  //           ),
  //         ]),
  //         Column(
  //           // Dữ liệu fix cứng do chưa thể tạo List medical Data
  //           children: List.generate(10, (i) {
  //             // Assuming you are tracking the checkbox states in a list of booleans
  //             return CheckboxListTile(
  //               title: ViewDataBox(
  //                 leadingiconpath: Item.getIconPath(int.parse(
  //                     diagnosticAddController.chosenmedical.value![i].typeId!)),
  //                 title: Item.getTitle(int.parse(
  //                     diagnosticAddController.chosenmedical.value![i].typeId!)),
  //                 value: diagnosticAddController.chosenmedical.value![i].value!,
  //                 unit: Item.getUnit(int.parse(
  //                     diagnosticAddController.chosenmedical.value![i].typeId!)),
  //                 noteController: controller.noteController,
  //                 time: DatetimeChange.getHourString(diagnosticAddController
  //                     .chosenmedical.value![i].time!
  //                     .toDate()),
  //               ),
  //               value:
  //                   diagnosticAddController.checkboxStates[i], // checkbox state
  //               onChanged: (bool? newValue) {
  //                 // Update the state of the checkbox when it's clicked
  //                 diagnosticAddController.checkboxStates[i] = newValue!;
  //                 // Call setState or update using GetX depending on how your state is managed
  //                 diagnosticAddController.update(); // if using GetX
  //               },
  //             );
  //           }),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDateTimeField(
  //     BuildContext context,
  //     String label,
  //     IconData icon,
  //     Future<void> Function(BuildContext) onTap,
  //     TextEditingController controller) {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     child: TextField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
  //         border: const OutlineInputBorder(),
  //         labelText: label,
  //       ),
  //       readOnly: true,
  //       onTap: () => onTap(context),
  //     ),
  //   );
  // }
}
