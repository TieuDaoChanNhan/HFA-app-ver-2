import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';

class DiagnosticText extends StatelessWidget {
  final controller = Get.find<DiagnosticAddController>();

  DiagnosticText({super.key});
  @override
  Widget build(BuildContext context) {
    return TextField(
      // minLines: 3,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Chẩn đoán',
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 16,
        ),
        hintText: 'Chẩn đoán',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 16,
        ),
        border: const OutlineInputBorder(),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.edit_note,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
      controller: controller.noteController,
    );
  }
}
