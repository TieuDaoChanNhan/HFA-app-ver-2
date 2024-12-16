import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/pages/connect_hardware/controller.dart';

class EcgFetched extends StatefulWidget {
  final String date;
  final String time;
  final List<String> index;
  final String value;
  final int medId;
  final DateTime pass;

  const EcgFetched({
    super.key,
    required this.date,
    required this.time,
    required this.value,
    required this.pass,
    required this.index,
    required this.medId,
  });

  @override
  State<EcgFetched> createState() => _EcgFetchedState();
}

class _EcgFetchedState extends State<EcgFetched> {
  // bool have_file1 = false;
  // bool have_file2 = false;
  // bool have_file3 = false;
  // bool have_file4 = false;
  final connectController = Get.find<ConnectHardwareController>();
  bool synced = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(Item.getIconPath(widget.medId)),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Item.getTitle(widget.medId),
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
                      Item.getUnit(widget.medId),
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
                          connectController.syncEcgData(
                              widget.pass,
                              widget.medId.toString(),
                              widget.index,
                              widget.value,
                              Item.getUnit(widget.medId),
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
