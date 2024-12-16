import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/profile/controller.dart';
import 'search_controller.dart';

class SearchingBar extends GetView<SearchingController> {
  final TextEditingController _controller = TextEditingController();
  final bool following;
  SearchingBar(this.following, {super.key});

  void _clearText() {
    _controller.clear();
    controller.onTextChanged('');
    FocusScope.of(Get.context!).unfocus(); // Dismiss the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: controller.onTextChanged,
          decoration: InputDecoration(
            hintText: following
                ? 'Thêm người muốn theo dõi dữ liệu'
                : 'Thêm người theo dõi',
            prefixIcon: Obx(() => IconButton(
                  icon: Icon(controller.hasText.value
                      ? Icons.arrow_back
                      : Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.primary,),
                  onPressed: () {
                    if (controller.hasText.value) {
                      _clearText();
                    }
                  },
                )),
            suffixIcon: Obx(() => controller.hasText.value
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearText,
                  )
                : const SizedBox.shrink()),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
        Obx(() {
          if (controller.searchResults.isEmpty) {
            return const SizedBox.shrink();
          }

          // GlobalKey to measure the height of the ListTile
          GlobalKey listTileKey = GlobalKey();
          double itemHeight = 70;

          // Measure the height of a single ListTile
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final context = listTileKey.currentContext;
            if (context != null) {
              log('Measuring height of ListTile');
              final box = context.findRenderObject() as RenderBox;
              itemHeight = box.size.height;
            }
          });

          const maxItems = 3;
          final itemCount = controller.searchResults.length;
          final height = itemCount > maxItems
              ? itemHeight * maxItems
              : itemHeight * itemCount;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color for the suggestion box
              borderRadius: BorderRadius.circular(16), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            constraints: BoxConstraints(maxHeight: height),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final follower = controller.searchResults[index];
                  return UserViewListTile(
                    key: index == 0
                        ? listTileKey
                        : null, // Assign key to the first item for measuring height
                    name: follower['name'],
                    email: follower['email'],
                    imageUrl: follower['photourl'],
                    onTap: () {
                      // Show dialog on tap
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _FollowerDialog(
                            follower: follower,
                            following: following,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}

class UserViewListTile extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final VoidCallback onTap;

  const UserViewListTile({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHigh, // Background color for the list item
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for each list item
      ),
      margin: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 8), // Margin between list items
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(email),
        onTap: onTap,
      ),
    );
  }
}

class _FollowerDialog extends StatefulWidget {
  final Map<String, dynamic> follower;
  final bool following;

  const _FollowerDialog({
    required this.follower,
    required this.following,
  });

  @override
  __FollowerDialogState createState() => __FollowerDialogState();
}

class __FollowerDialogState extends State<_FollowerDialog> {
  String? selectedCategory;
  final controller = Get.find<ProfileController>();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.follower['photourl']),
              ),
              title: Text(widget.follower['name']),
              subtitle: Text(widget.follower['email']),
            ),
            const SizedBox(height: 16),
            Text('Thêm người theo dõi',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceChip(
                  label: const Text('Người nhà'),
                  selected: selectedCategory == 'Người nhà',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategory = selected ? 'Người nhà' : null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Chuyên gia y tế'),
                  selected: selectedCategory == 'Chuyên gia y tế',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategory = selected ? 'Chuyên gia y tế' : null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Hủy', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the confirmation button press
                    if (selectedCategory != null) {
                      log('Confirmed: $selectedCategory');
                      // ignore: avoid_print
                      log('id : ${widget.follower['id']}');
                      if (selectedCategory == 'Người nhà') {
                        controller.sendRequest(
                            widget.follower['id'], 'relative');
                        FirebaseMessagingApi.sendMessage(
                          widget.follower['fcmtoken'],
                          'Yêu cầu làm người nhà ',
                          "${appController.state.profile.value!.name!} muốn trở thành người nhà của bạn",
                          'unread',
                          'follow',
                          widget.follower['id'],
                          'common',
                        );
                      } else {
                        if (widget.following) {
                          controller.sendRequest(
                              widget.follower['id'], 'doctor');
                          FirebaseMessagingApi.sendMessage(
                            widget.follower['fcmtoken'],
                            'Yêu cầu làm bác sĩ ',
                            "${appController.state.profile.value!.name!} muốn trở trành bác sĩ của bạn",
                            "unread",
                            "follow",
                            widget.follower['id'],
                            'common',
                          );
                        } else {
                          controller.sendRequest(
                              widget.follower['id'], 'patient');
                          FirebaseMessagingApi.sendMessage(
                              widget.follower['fcmtoken'],
                              'Yêu cầu làm bệnh nhân ',
                              "${appController.state.profile.value!.name!} muốn trở trành bệnh nhân của bạn",
                              "unread",
                              "follow",
                              widget.follower['id'],
                              'common');
                        }
                      }
                    }
                    // Get.back();
                  },
                  child: const Text('Xác nhận'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
