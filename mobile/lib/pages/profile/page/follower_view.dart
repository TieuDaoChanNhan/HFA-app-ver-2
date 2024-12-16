import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/profile/controller.dart';
import 'package:health_for_all/pages/profile/page/add_doctor.dart';
import 'package:health_for_all/pages/profile/widget/user_ListTile.dart';
import 'search_view.dart';

class FollowerPage extends StatefulWidget {
  const FollowerPage({super.key});
  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final relativesIds =
        controller.appController.state.profile.value?.relatives ?? [];
    final doctorsIds =
        controller.appController.state.profile.value?.doctors ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const AddDoctor(),
            const SizedBox(
              height: 8,
            ),
            SearchingBar(false),
            const SizedBox(height: 20),
            Text(
              'Người thân (${relativesIds.length})',
            ),
            const Divider(),
            if (relativesIds.isEmpty)
              const Center(child: Text("Chưa có người thân"))
            else
              StreamBuilder(
                stream: controller.getUserByIds(relativesIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Lỗi khi tải người thân!'));
                  } else if (snapshot.hasData) {
                    final users = snapshot.data ?? [];
                    if (users.isEmpty) {
                      return const Center(child: Text("Chưa có người thân"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return UserListTile(
                          name: user.name!,
                          description: user.id!,
                          imageUrl: user.photourl!,
                          onTap: () {},
                          id: controller.appController.state.profile.value!.id!,
                          collection: 'users',
                          fieldName: 'relatives',
                          valueToRemove: user.id!,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Chưa có người thân"));
                  }
                },
              ),
            const SizedBox(height: 5),
            Text(
              'Chuyên gia y tế (${doctorsIds.length})',
            ),
            const Divider(),
            if (doctorsIds.isEmpty)
              const Center(child: Text("Chưa có bác sĩ"))
            else
              StreamBuilder(
                stream: controller.getUserByIds(doctorsIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Lỗi khi tải bác sĩ!'));
                  } else if (snapshot.hasData) {
                    final users = snapshot.data ?? [];
                    if (users.isEmpty) {
                      return const Center(child: Text("Chưa có bác sĩ"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return UserListTile(
                          id: controller.appController.state.profile.value!.id!,
                          collection: 'users',
                          fieldName: 'doctors',
                          valueToRemove: user.id!,
                          name: user.name!,
                          description: user.id!,
                          imageUrl: user.photourl!,
                          onTap: () {},
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Chưa có bác sĩ"));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
