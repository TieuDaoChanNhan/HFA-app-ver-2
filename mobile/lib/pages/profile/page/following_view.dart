import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/pages/profile/controller.dart';
import 'package:health_for_all/pages/profile/page/search_view.dart';
import 'package:health_for_all/pages/profile/widget/user_ListTile.dart';
import 'package:health_for_all/pages/profile/widget/user_request_listTile.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});
  final bool follow = true;
  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchingBar(true),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Người thân (${controller.appController.state.profile.value!.relatives!.length})'),
            const Divider(),
            // Use the custom ListTile widgets here
            StreamBuilder(
              stream: controller.getUserByIds(
                  controller.appController.state.profile.value!.relatives!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Chưa có người thân!'),
                  );
                } else if (snapshot.hasData) {
                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return const Center(
                      child: Text("Chưa có người thân"),
                    );
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
                  return const Center(
                    child: Text("Chưa có người thân!!!"),
                  );
                }
              },
            ),

            Text(
                'Bệnh nhân (${controller.appController.state.profile.value!.patients!.length})'),
            const Divider(),
            // Use the custom ListTile widgets here
            StreamBuilder(
              stream: controller.getUserByIds(
                  controller.appController.state.profile.value!.patients!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Chưa có bệnh nhân!'),
                  );
                } else if (snapshot.hasData) {
                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return const Center(
                      child: Text("Chưa có bệnh nhân"),
                    );
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
                          fieldName: 'patients',
                          valueToRemove: user.id!);
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Chưa có bệnh nhân!!!"),
                  );
                }
              },
            ),
            // ignore: prefer_const_constructors
            Text(
              'Chờ được duyệt ',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const Divider(),
            StreamBuilder(
              stream: controller.getRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Chưa có yêu cầu!'),
                  );
                } else if (snapshot.hasData) {
                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return const Center(
                      child: Text("Chưa có yêu cầu"),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserRequestListtile(
                        name: user.user!.name!,
                        description: user.user!.id!,
                        imageUrl: user.user!.photourl!,
                        role: user.role! == 'doctor'
                            ? 'Bác sĩ'
                            : user.role! == 'patient'
                                ? 'Bệnh nhân'
                                : 'Người thân',
                        onDone: () async {
                          // Xử lý cho vai trò 'doctor'
                          if (user.role == 'doctor') {
                            try {
                              final a1 = await FirebaseApi.addValueToArrayField(
                                'users',
                                user.user!.id!,
                                'patients',
                                controller
                                    .appController.state.profile.value!.id!,
                              );
                              final a2 = await FirebaseApi.addValueToArrayField(
                                'users',
                                controller
                                    .appController.state.profile.value!.id!,
                                'doctors',
                                user.user!.id!,
                              );

                              if (a1 && a2) {
                                await FirebaseApi.deleteDocument(
                                  'requestFollows',
                                  user.docID!,
                                );
                                print('Document deleted successfully');
                              } else {
                                print('Failed to add values to array fields');
                              }
                            } catch (e) {
                              print('Error occurred: $e');
                            }
                          }
                          if (user.role == 'patient') {
                            try {
                              final a1 = await FirebaseApi.addValueToArrayField(
                                'users',
                                user.user!.id!,
                                'doctors',
                                controller
                                    .appController.state.profile.value!.id!,
                              );
                              final a2 = await FirebaseApi.addValueToArrayField(
                                'users',
                                controller
                                    .appController.state.profile.value!.id!,
                                'patients',
                                user.user!.id!,
                              );

                              if (a1 && a2) {
                                await FirebaseApi.deleteDocument(
                                  'requestFollows',
                                  user.docID!,
                                );
                                print('Document deleted successfully');
                              } else {
                                print('Failed to add values to array fields');
                              }
                            } catch (e) {
                              print('Error occurred: $e');
                            }
                          }

                          if (user.role == 'relative') {
                            try {
                              final a1 = await FirebaseApi.addValueToArrayField(
                                'users',
                                user.user!.id!,
                                'relatives',
                                controller
                                    .appController.state.profile.value!.id!,
                              );
                              final a2 = await FirebaseApi.addValueToArrayField(
                                'users',
                                controller
                                    .appController.state.profile.value!.id!,
                                'relatives',
                                user.user!.id!,
                              );

                              if (a1 && a2) {
                                await FirebaseApi.deleteDocument(
                                  'requestFollows',
                                  user.docID!,
                                );
                                print('Document deleted successfully');
                              } else {
                                print('Failed to add values to array fields');
                              }
                            } catch (e) {
                              print('Error occurred: $e');
                            }
                          }
                        },
                        onClear: () async {
                          await FirebaseApi.deleteDocument(
                              'requestFollows', user.docID!);
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Chưa có bác sĩ!!!"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
