import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/profile/controller.dart';
import 'package:health_for_all/pages/profile/page/follower_view.dart';
import 'package:health_for_all/pages/profile/page/following_view.dart';
import 'package:health_for_all/pages/profile/page/information_view.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin cá nhân'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Thông tin', style: TextStyle(fontSize: 14),),
              ),
              Tab(
                child: Text('Người theo dõi', style: TextStyle(fontSize: 14),),
              ),
              Tab(
                child: Text('Đang theo dõi', style: TextStyle(fontSize: 14),),
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.appController.state.profile.value != null
              ? const TabBarView(
                  children: [
                    InformationPage(),
                    FollowerPage(),
                    FollowingPage(),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
