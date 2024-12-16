import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/pages/alarm/controller.dart';

class ListAlarm extends StatelessWidget {
  final int index;
  String? highThreshold;
  String? lowThreshold;
  bool? enable;
  String? id;
  ListAlarm(
      {super.key,
      required this.index,
      this.highThreshold,
      this.lowThreshold,
      this.enable,
      this.id});
  final alarmController = Get.find<AlarmController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                spreadRadius: 0.6,
                blurRadius: 2,
              )
            ],
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.asset(Item.getIconPath(index), height: 32, width: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Item.getTitle(index),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      Item.getUnit(index),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cao:",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Thấp:",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          highThreshold ?? "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          lowThreshold ?? "",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  alarmController.deleteAlarm(id!);
                },
                child: Icon(
                  Icons.clear_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              // SizedBox(width: 16,),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: enable ?? false,
                  onChanged: (value) {
                    alarmController.changeEnable(id!, value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  // void _showAddDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: 10),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               EditAlarm(
  //                   index: index,
  //                   highThreshold: highThreshold,
  //                   lowThreshold: lowThreshold,
  //                   id: id),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
