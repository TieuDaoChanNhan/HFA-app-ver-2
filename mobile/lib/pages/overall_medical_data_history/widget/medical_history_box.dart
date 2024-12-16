import 'package:flutter/material.dart';

class MedicalHistoryBox extends StatefulWidget {
  final String time;
  final String value;
  final String unit;

  const MedicalHistoryBox(
      {super.key, required this.time, required this.value, required this.unit});

  @override
  State<MedicalHistoryBox> createState() => MedicalHistoryBoxState();
}

class MedicalHistoryBoxState extends State<MedicalHistoryBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 372,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 28,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 170,
              height: 28,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 52,
              height: 28,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
