import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../controller.dart';

class CropImage extends StatefulWidget {
  const CropImage({super.key});

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  late FlutterVision vision;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoloVideo(vision: vision),
    );
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({super.key, required this.vision});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> with WidgetsBindingObserver {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();

    await loadYoloModel();
    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  Future<void> cropAndNavigate(
      CameraImage cameraImage, Map<String, dynamic> box) async {
    try {
      img.Image croppedImage = await cropCameraImage(cameraImage, box);
      // medicalController.state.selectedFile.value =
      //     await saveImageToFile(croppedImage, 'cropped.jpg');
      final file = await saveImageToFile(croppedImage, 'cropped.jpg');
      // Ensure the state is updated before navigating back
      setState(() {
        isDetecting = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        // Get.back();
        Get.to(() => DisplayImage(
              imageFile: File(file.path),
            ));
      });
    } catch (e) {
      log('Error during crop and navigate: $e');
      // Optionally, show an error message to the user
      Get.snackbar('Error', 'Failed to process the image.');
    }
  }

  Future<XFile> saveImageToFile(img.Image image, String filename) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';

    File(filePath).writeAsBytesSync(img.encodeJpg(image));

    return XFile(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    final double aspectRatio = controller.value.aspectRatio;
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.rotate(
          angle: (controller.description.sensorOrientation -
                  (deviceOrientation == Orientation.portrait ? 90 : 0)) *
              pi /
              180,
          child: Center(
            child: FittedBox(
              fit: BoxFit
                  .cover, // Phóng to camera để khớp với màn hình, cắt đi các phần dư
              child: SizedBox(
                width: size.width, // Đảm bảo tỷ lệ camera được giữ nguyên
                height: size.width *
                    aspectRatio, // Đảm bảo tỷ lệ camera được giữ nguyên
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5, color: Colors.white, style: BorderStyle.solid),
            ),
            child: isDetecting
                ? IconButton(
                    onPressed: stopDetection,
                    icon: const Icon(
                      Icons.stop,
                      color: Colors.red,
                    ),
                    iconSize: 50,
                  )
                : IconButton(
                    onPressed: startDetection,
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
      labels: 'assets/AI_model/labels.txt',
      modelPath: 'assets/AI_model/best_float32.tflite',
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: true,
    );
  }

  img.Image _convertYUV420ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final int yRowStride = image.planes[0].bytesPerRow;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final img.Image imghehe = img.Image(
      width: width,
      height: height,
    ); // Create Image buffer

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;
        final int yValue = image.planes[0].bytes[y * yRowStride + x];
        final int uValue = image.planes[1].bytes[uvIndex];
        final int vValue = image.planes[2].bytes[uvIndex];

        final int r =
            (yValue + (1.370705 * (vValue - 128))).toInt().clamp(0, 255);
        final int g =
            (yValue - (0.698001 * (vValue - 128)) - (0.337633 * (uValue - 128)))
                .toInt()
                .clamp(0, 255);
        final int b =
            (yValue + (1.732446 * (uValue - 128))).toInt().clamp(0, 255);

        imghehe.setPixel(x, y, imghehe.getColor(r, g, b));
      }
    }
    img.Image rotatedImage = img.copyRotate(imghehe,
        angle: controller.description.sensorOrientation);
    return rotatedImage;
  }

  Future<img.Image> cropCameraImage(
      CameraImage cameraImage, Map<String, dynamic> box) async {
    // Chuyển đổi CameraImage sang định dạng RGB
    img.Image rgbImage = _convertYUV420ToImage(cameraImage);

    // Kích thước của ảnh gốc (CameraImage)
    int imageWidth = rgbImage.width;
    int imageHeight = rgbImage.height;

    // Toạ độ YOLO cung cấp là dựa trên kích thước ảnh camera, không phải kích thước màn hình
    double boxX1 = box['box'][0]; // Toạ độ x trên ảnh gốc
    double boxY1 = box['box'][1]; // Toạ độ y trên ảnh gốc
    double boxX2 = box['box'][2]; // Toạ độ x cuối cùng
    double boxY2 = box['box'][3]; // Toạ độ y cuối cùng

    // Kích thước và toạ độ vùng nhận diện cần cắt
    int x = boxX1.round();
    int y = boxY1.round();
    int width = (boxX2 - boxX1).round();
    int height = (boxY2 - boxY1).round();

    log("Tọa độ X: $x, Y: $y, Chiều rộng: $width, Chiều cao: $height");

    // Cắt ảnh theo các toạ độ đã tính toán
    img.Image croppedImage = img.copyCrop(
      rgbImage,
      x: x.clamp(0, imageWidth - 1), // Đảm bảo toạ độ không vượt quá giới hạn
      y: y.clamp(0, imageHeight - 1),
      width: width.clamp(1, imageWidth - x), // Đảm bảo chiều rộng hợp lý
      height: height.clamp(1, imageHeight - y), // Đảm bảo chiều cao hợp lý
    );

    return croppedImage;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }
    log("AppLifecycleState: $state");
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      log("Dispose camera controller");
    } else if (state == AppLifecycleState.resumed) {
      log("Init camera controller");
      init();
    }
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          yoloResults = result;
        });
      }

      if (yoloResults.first['box'][4] > 0.9) {
        await cropAndNavigate(cameraImage, result.first);
      }
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        yoloOnFrame(image); // Call YOLO on the frame
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
    await controller.stopImageStream(); // Stop the image stream
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (controller.value.previewSize!.height);
    double factorY = screen.height / (controller.value.previewSize!.width);
    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;

  PolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 2, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DisplayImage extends StatelessWidget {
  final File imageFile;

  DisplayImage({super.key, required this.imageFile});
  final medicalController = Get.find<MedicalDataController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ảnh hậu xử lí'),
      ),
      body: Column(children: [
        Expanded(
          child: Image.file(imageFile),
        ),
        ElevatedButton(
          onPressed: () {
            medicalController.state.selectedFile.value = XFile(imageFile.path);
            Get.back();
            Get.back();
          },
          child: const Text('Phân tích hình ảnh'),
        ),
      ]),
    );
  }
}
