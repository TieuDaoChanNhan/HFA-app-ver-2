import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/reminder/controller.dart';

class SwitchedBox extends StatefulWidget {
  const SwitchedBox(
      {super.key,
      required this.name,
      required this.numReminder,
      required this.time,
      required this.numDate,
      required this.onDate,
      required this.date,
      required this.reminderId});
  final String name;
  final int numReminder;
  final String time;
  final int numDate;
  final List<bool> onDate;
  final String date;
  final String reminderId;

  @override
  State<SwitchedBox> createState() => _SwitchedBoxState();
}

class _SwitchedBoxState extends State<SwitchedBox> {
  final ReminderController reminderController = Get.put(ReminderController());
  bool isSwitched = false; // Initialize the switch state

  @override
  void initState() {
    super.initState();
    // Initialize the switch state based on the ReminderController's checkDate
    isSwitched = ReminderController().checkDate(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            spreadRadius: 0.6,
            blurRadius: 2,
          )
        ],
        color: isSwitched
            ? Theme.of(context).colorScheme.surfaceContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.date_range_outlined,
            size: 32,
            color: isSwitched
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: isSwitched
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.outline,
                    fontSize: 14,
                  ),
                ),
                if (widget.numReminder == 0)
                  Text(
                    "-",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12,
                    ),
                  )
                else
                  Text(
                    "${widget.numReminder} lời nhắc",
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
                      widget.time,
                      style: TextStyle(
                        color: isSwitched
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.outline,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.numDate == 7)
                      Text(
                        "Hằng ngày",
                        style: TextStyle(
                          fontSize: 12,
                          color: isSwitched
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      )
                    else
                      Row(
                        children: [
                          for (int i = 0; i < 7; i++)
                            if (!widget.onDate[i])
                              Row(
                                children: [
                                  Text(
                                    (i + 2).toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  if (i != 6)
                                    const SizedBox(
                                      width: 4,
                                    ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Text(
                                    (i + 2).toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSwitched
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                    ),
                                  ),
                                  if (i != 6)
                                    const SizedBox(
                                      width: 4,
                                    ),
                                ],
                              )
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              reminderController.delReminder(widget.reminderId);
            },
            child: Icon(
              Icons.clear_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value; // Use setState to update the UI
                  });
                }),
          ),
        ],
      ),
    );
  }
}
