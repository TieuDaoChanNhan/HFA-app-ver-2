import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/application/controller.dart';

class PatientBox extends StatelessWidget {
  final UserData user;

  PatientBox({super.key, required this.user});

  final appController = Get.find<ApplicationController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 1),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromRGBO(0, 0, 0, 0.3),
        //     spreadRadius: 1,
        //     blurRadius: 2,
        //   )
        // ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(user.photourl!),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                user.name!,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Giới tính: ${user.gender!}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Text(
                'Tuổi: ${user.age!}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          const Spacer(),
          IntrinsicWidth(
            child: SizedBox(
              height: 52,
              child: Column(
                children: [
                  Container(
                    // width: 100,
                    // height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text(
                      user.id == appController.state.profile.value!.id
                          ? 'Bản thân'
                          : appController.state.profile.value!.isDoctor == true
                              ? 'Bệnh nhân'
                              : 'Người nhà',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
