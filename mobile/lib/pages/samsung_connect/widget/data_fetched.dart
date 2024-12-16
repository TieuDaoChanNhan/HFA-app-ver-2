import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/pages/samsung_connect/controller.dart';

class DataDay extends StatefulWidget {
  final String date;
  final String time;
  final String value;
  final int index;
  final DateTime pass;

  const DataDay({
    super.key,
    required this.date,
    required this.time,
    required this.value,
    required this.index,
    required this.pass,
  });

  @override
  State<DataDay> createState() => _DataDayState();
}

class _DataDayState extends State<DataDay> {
  // bool have_file1 = false;
  // bool have_file2 = false;
  // bool have_file3 = false;
  // bool have_file4 = false;
  final connectController = Get.find<SamsungConnectController>();
  bool synced = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(Item.getIconPath(widget.index)),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Item.getTitle(widget.index),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    // Adds space between hour and index
                    Text(
                      widget.value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      Item.getUnit(widget.index),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: !synced
                    ? ElevatedButton(
                        onPressed: () {
                          connectController.syncMedData(
                              widget.pass,
                              widget.index.toString(),
                              widget.value,
                              Item.getUnit(widget.index),
                              context);
                          setState(() {
                            synced = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Container(
                          child: const Text(
                            "Đồng Bộ",
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.outline,
                        ),
                        child: Container(
                          child: const Text(
                            "Đã Đồng Bộ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),

              // Icons for additional actions in the same row
              // const SizedBox(width: 16),
              // icon_round(have_file1, icon: Icons.edit_note_outlined),
              // const SizedBox(width: 6),
              // icon_round(have_file2, icon: Icons.attach_file_outlined),
              // const SizedBox(width: 6),
              // icon_round(have_file3, icon: Icons.comment_outlined),
              // const SizedBox(width: 6),
              // if (have_file4)
              //   image_round("assets/images/result2.png")
              // else
              //   image_round("assets/images/result1.png"),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }

  // Method to display icon in rounded container
  Widget icon_round(bool ok, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: ok
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        size: 18,
      ),
    );
  }

  // Method to display image in rounded container
  Widget image_round(String path) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        path,
        height: 18,
        width: 18,
      ),
    );
  }
}
