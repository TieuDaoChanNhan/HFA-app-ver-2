import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/following/Widget/PinkBox.dart';
import 'package:health_for_all/pages/following/controller.dart';
import 'package:health_for_all/pages/following_medical_data/view.dart';
import 'package:health_for_all/pages/profile/controller.dart';

class Following extends GetView<FollowingController> {
  final appController = Get.find<ApplicationController>();
  final profileController = Get.find<ProfileController>();

  Following({super.key});

  @override
  Widget build(BuildContext context) {
    final relativesIds = appController.state.profile.value?.relatives ?? [];
    final patientsIds = appController.state.profile.value?.patients ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, relativesIds.length + patientsIds.length),
            const SizedBox(height: 16),
            _buildRelativesList(relativesIds),
            const SizedBox(height: 16),
            _buildPatientsList(patientsIds),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      // padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_added_outlined,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 18,
                    child: Text(
                      "Đang theo dõi",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 17,
              height: 16,
              child: Text(
                '($count)',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelativesList(List<String> relativesIds) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: profileController.getUserByIds(relativesIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Chưa có người thân!'));
          } else if (snapshot.hasData) {
            final users = snapshot.data ?? [];
            controller.state.relatives = users;
            if (users.isEmpty) {
              return const Center(child: Text("Chưa có người thân"));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    _buildUserTile(user, "Người thân"),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("Chưa có người thân"));
          }
        },
      ),
    );
  }

  Widget _buildPatientsList(List<String> patientsIds) {
    return StreamBuilder(
      stream: profileController.getUserByIds(patientsIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Chưa có bệnh nhân!'));
        } else if (snapshot.hasData) {
          final users = snapshot.data ?? [];
          controller.state.patients = users;
          if (users.isEmpty) {
            return const Center(child: Text("Chưa có bệnh nhân"));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Column(
                children: [
                  _buildUserTile(user, "Bệnh nhân"),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text("Chưa có bệnh nhân"));
        }
      },
    );
  }

  Widget _buildUserTile(UserData user, String role) {
    return GestureDetector(
      onTap: () {
        appController.state.selectedUserId.value = user.id ?? "";
        appController.state.selectedUser.value = user;
        log('User id: ${appController.state.selectedUser.value.id}');
        appController.getUpdatedLatestMedical();
        Get.to(() => Obx(() => FollowingMedicalData(
              user: user,
              role: role,
              time: controller.updatedTimeMap[user.id] ?? '',
            )));
      },
      child: Obx(() {
        final time = controller.updatedTimeMap[user.id] ?? '';
        final alarmCount = controller.alarmCountMap[user.id]?.toString() ?? '0';
        return Pinkbox(
          user: user,
          time: time,
          role: role,
          alarmCount: alarmCount,
        );
      }),
    );
  }
}
