import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/profile/page/list_doctor.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        Get.to(() => ListDoctor());
      },
      readOnly: true,
      controller: TextEditingController(),
      decoration: InputDecoration(
        hintText: "Thêm chuyên gia y tế",
        prefixIcon: Icon(
          Icons.add_circle_outline,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }
}
