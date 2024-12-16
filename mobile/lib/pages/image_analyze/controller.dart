import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_for_all/pages/application/controller.dart';

class ImageAnalyzeController extends GetxController {
  ImageAnalyzeController();

  final state = ImageAnalyzeState();
  final appController = Get.find<ApplicationController>();

  final model = GenerativeModel(
    model: 'gemini-1.5-pro-001',
    apiKey: dotenv.env['GOOGLE_API_KEY']!,
    systemInstruction: Content.system('''
    {
      "goal": "Analyze blood pressure images and return the systolic and diastolic values as integer variables.",
      "output_format": "Dart Code",
      "example_output": "
        int systolic = 0;
        int diastolic = 0;
      ",
      "rules": [
        "Return only the variable declarations.",
        "Do not include any additional explanations or comments."
      ]
    }
    '''),
  );

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      state.image.value = File(image.path);
    } else {
      // Người dùng không chọn ảnh
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      state.image.value = File(image.path);
    } else {
      // Người dùng không chụp ảnh
    }
  }

  Future<void> analyzeImage() async {
    if (state.image.value == null) return;

    try {
      EasyLoading.show(status: "Đang xử lí...");
      final imageBytes = await state.image.value!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      state.analysisResult.value = 'Đang phân tích...';

      final result = await model.generateContent([
        Content.multi([imagePart])
      ], generationConfig: GenerationConfig(maxOutputTokens: 250));

      final resultText = result.text ?? '';

      // Use regular expressions to extract systolic and diastolic values from the AI's response
      RegExp systolicRegExp = RegExp(r'int systolic = (\d+);');
      RegExp diastolicRegExp = RegExp(r'int diastolic = (\d+);');

      int? extractedSystolic =
          int.tryParse(systolicRegExp.firstMatch(resultText)?.group(1) ?? '');
      int? extractedDiastolic =
          int.tryParse(diastolicRegExp.firstMatch(resultText)?.group(1) ?? '');

      if (extractedSystolic != null && extractedDiastolic != null) {
        state.systolic.value = extractedSystolic;
        state.diastolic.value = extractedDiastolic;
        state.analysisResult.value =
            'Số đo huyết áp là: $extractedSystolic/$extractedDiastolic mmHg';
      } else {
        state.analysisResult.value = 'Không thể phân tích số đo huyết áp.';
      }
    } catch (e) {
      state.analysisResult.value = 'Lỗi phân tích hình ảnh: $e';
    }
    finally{
      EasyLoading.dismiss();
    }
  }
}

class ImageAnalyzeState {
  Rx<File?> image = Rx<File?>(null);
  Rx<int> systolic = Rx<int>(0);
  Rx<int> diastolic = Rx<int>(0);
  Rx<String> analysisResult = Rx<String>('Chưa có kết quả phân tích');
}
