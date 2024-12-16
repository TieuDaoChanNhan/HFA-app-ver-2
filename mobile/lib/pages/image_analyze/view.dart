import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class ImageAnalyzePage extends StatelessWidget {
  final ImageAnalyzeController controller = Get.put(ImageAnalyzeController());

  ImageAnalyzePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phân tích hình ảnh')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: controller.pickImageFromGallery,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Thêm file'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: controller.pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.state.image.value != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(controller.state.image.value!,
                        height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: controller.analyzeImage,
                      child: const Text('Phân tích'),
                    ),
                  ],
                );
              } else {
                return const Text('Chưa có file đính kèm');
              }
            }),
            const SizedBox(height: 20),
            const Text('Kết quả phân tích',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(() {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.state.analysisResult.value),
                    if (controller.state.systolic.value != 0 &&
                        controller.state.diastolic.value != 0)
                      Text('Systolic: ${controller.state.systolic.value} mmHg'),
                    if (controller.state.systolic.value != 0 &&
                        controller.state.diastolic.value != 0)
                      Text(
                          'Diastolic: ${controller.state.diastolic.value} mmHg'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
