import 'package:flutter/material.dart';

class AlarmWidget extends StatefulWidget {
  final String name;
  final String time;
  final String date;
  final String state;
  final String medName;
  final String index;
  final String commend;
  const AlarmWidget(
      {super.key,
      required this.name,
      required this.time,
      required this.date,
      required this.state,
      required this.medName,
      required this.index,
      required this.commend});

  @override
  State<AlarmWidget> createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.reviews_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  seperator(Colors.black),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                  seperator(Colors.black),
                  Text(
                    "${widget.time} , ${widget.date}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    widget.state,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  seperator(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    widget.medName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  seperator(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    widget.index,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    widget.commend,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget seperator(Color color) {
    return Row(
      children: [
        const SizedBox(
          width: 6,
        ),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
