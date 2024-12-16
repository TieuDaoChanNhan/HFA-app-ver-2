import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/chatbot.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/chatbot/state.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotController extends GetxController {
  ChatbotController();
  final TextEditingController textController = TextEditingController();
  final FocusNode textNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final state = ChatbotState();
  final appController = Get.find<ApplicationController>();
  // final appController = Get.find<ApplicationController>();
  Rx<ChatbotEntity> data = ChatbotEntity().obs;
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['GOOGLE_API_KEY']!,
    systemInstruction: Content.system(
        'Bạn là một người bác sĩ. Bạn tên là HFA. Bạn là sản phẩm AI của nhóm nghiên cứu khoa học trường Amsterdam.'
        ' Bạn sẽ hỗ trợ mọi người thông qua các câu hỏi liên quan đến sức khoẻ và các chỉ số y tế, ngoài ra bạn có'
        ' thể đọc hình ảnh là các chỉ số từ máy đo y tế và phân tích và trả về số liệu, từ đó bạn đưa ra đánh giá và lời khuyên cho họ'),
  );

  @override
  void onInit() async {
    super.onInit();
    await getHistory();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future getHistory() async {
    final uid = appController.state.profile.value?.id!;
    log("dakmim $uid");
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chatbots')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    final chatList = querySnapshot.docs.map((doc) {
      return ChatbotEntity.fromFirestore(doc);
    }).toList();

    state.chatList.clear();
    state.chatList.addAll(chatList);
    scrollToEnd();
  }

  Future sendMessage() async {
    final query = textController.text;
    if (query.isEmpty) return;
    textController.clear();
    final content = [Content.text(query)];
    data.value = ChatbotEntity(
        role: 'User',
        uid: appController.state.profile.value?.id!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        content: query,
        image: "");
    await FirebaseApi.addDocument('chatbots', data.value.toMap());
    state.chatList.insert(0, data.value);
    scrollToEnd();
    await model
        .generateContent(content, generationConfig: GenerationConfig())
        .then((value) {
      data.value = ChatbotEntity(
          role: 'HFA',
          uid: appController.state.profile.value?.id!,
          timestamp: Timestamp.fromDate(DateTime.now()),
          image: '',
          content: value.text);
      FirebaseApi.addDocument('chatbots', data.value.toMap());

      state.chatList.insert(0, data.value);
    });
    scrollToEnd();
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      state.image.value = image;
      await sendMessage();
    } else {
      // Người dùng không chọn ảnh
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      state.image.value = image;
    } else {
      // Người dùng không chụp ảnh
    }
  }

  Future sendImageWithMessage() async {
    final query = textController.text;
    if (query.isEmpty) return;
    textController.clear();
    final image =
        await FirebaseApi.uploadImage(state.image.value!.path, 'chatbots');
    data.value = ChatbotEntity(
        role: 'User',
        uid: appController.state.profile.value?.id!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        content: query,
        image: image ?? "");
    await FirebaseApi.addDocument('chatbots', data.value.toMap());
    state.chatList.insert(0, data.value);

    final imageBytes = await state.image.value!.readAsBytes();

    final prompt = TextPart(query);
    final imagePart = DataPart('image/jpeg', imageBytes);

    scrollToEnd();
    state.image.value = null;
    await model.generateContent([
      Content.multi([prompt, imagePart])
    ], generationConfig: GenerationConfig(maxOutputTokens: 250)).then((value) {
      data.value = ChatbotEntity(
          role: 'HFA',
          uid: appController.state.profile.value?.id!,
          timestamp: Timestamp.fromDate(DateTime.now()),
          image: '',
          content: value.text);
      state.chatList.insert(0, data.value);
    });
    await FirebaseApi.addDocument('chatbots', data.value.toMap());
    scrollToEnd();
  }

  void scrollToEnd() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position
            .minScrollExtent, // In reverse mode, this is typically the "end"
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void clearChatHistory() {
    state.chatList.clear(); // Clears the local chat list
    update(); // Notifies the UI to update if necessary
  }

  Future<void> deleteChatHistoryFromFirestore() async {
    final uid = appController.state.profile.value?.id!;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chatbots')
        .where('uid', isEqualTo: uid)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    // Clear the local chat list
    clearChatHistory();
  }
}
