import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/chatbot/controller.dart';
import 'package:health_for_all/pages/chatbot/widget/chat_list.dart';

class ChatbotPage extends GetView<ChatbotController> {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với HFA'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              const Expanded(
                child: ChatList(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        GestureDetector(
                          child: Icon(
                            Icons.photo_outlined,
                            size: 23,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            controller.pickImageFromGallery();
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          child: Icon(
                            Icons.camera_outlined,
                            size: 23,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            controller.pickImageFromCamera();
                          },
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: Theme.of(context).colorScheme.surfaceDim,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Adjust height based on content
                              children: [
                                Obx(() {
                                  if (controller.state.image.value != null) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(controller
                                                .state.image.value!.path),
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.state.image.value =
                                                  null;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.clear_outlined,
                                                color: Colors.black,
                                                size:
                                                    12, // Adjusted size for better visibility
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return const SizedBox
                                        .shrink(); // Returns an empty widget if no image
                                  }
                                }),
                                Flexible(
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    controller: controller.textController,
                                    autofocus: false,
                                    focusNode: controller.textNode,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          if (controller
                                              .textController.text.isNotEmpty) {
                                            if (controller.state.image.value !=
                                                null) {
                                              await controller
                                                  .sendImageWithMessage();
                                            } else {
                                              await controller.sendMessage();
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Xin hãy nhập tin nhắn."),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Nhập tin nhắn ...",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                    ),
                                    onTap: () {
                                      for (var i in controller.state.chatList) {
                                        log(i.toString());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 5),
                          height: 35,
                          child: ElevatedButton(
                            child: const Text("Xóa"),
                            onPressed: () async {
                              controller.deleteChatHistoryFromFirestore();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
