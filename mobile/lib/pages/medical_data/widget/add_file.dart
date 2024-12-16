import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/medical_data/widget/crop_image.dart';
import 'package:image_picker/image_picker.dart';

import '../controller.dart';

class AddFile extends StatefulWidget {
  AddFile({super.key, this.files, this.onFilesChanged, required this.medName});

  List<XFile>? files;
  final Function(List<XFile>)? onFilesChanged;
  final String medName;

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedFiles = <XFile>[].obs;
  final controller = Get.find<MedicalDataController>();
  @override
  void initState() {
    super.initState();
    if (widget.files != null) {
      selectedFiles.addAll(widget.files!);
    }
  }

  void pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      selectedFiles.addAll(images);
      widget.onFilesChanged?.call(selectedFiles); // Notify parent about changes
    });
  }
  void openCamera() async {
    final XFile? images = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      selectedFiles.add(images!);
      widget.onFilesChanged?.call(selectedFiles); // Notify parent about changes
    });
  }

  void capturePhoto() {
    if (widget.medName != "Huyết áp"){
      openCamera();
      return;
    }
    log('Capture photo');
    Get.to(() => const CropImage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Thêm file
              TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.attach_file,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: pickMultipleImages,
                label: Text(
                  'Thêm file',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Camera
              TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: capturePhoto,
                label: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Obx(() {
                if (controller.state.selectedFile.value != null) {
                  log('Photo selected: ${controller.state.selectedFile.value!.path}');
                  selectedFiles.add(controller.state.selectedFile.value!);
                  widget.onFilesChanged
                      ?.call(selectedFiles); // Notify parent about changes
                } else {
                  log('No photo selected.');
                }
                return Container(); // Return a non-nullable widget
              })
            ],
          ),
          const SizedBox(height: 16),
          _buildFileList(),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    if (selectedFiles.isEmpty) {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(4),
        dashPattern: const [2, 3],
        color: Theme.of(context).colorScheme.outline,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          alignment: Alignment.topLeft,
          child: Text(
            'Chưa có file đính kèm',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 50, // Adjust this value based on your layout needs
        ),
        child: Obx(()=>ListView.builder(
          itemCount: selectedFiles.length,
          itemBuilder: (context, index) {
            final XFile file = selectedFiles[index];
            return _buildFileItem(file);
          },
        )),
      );
    }
  }

  Widget _buildFileItem(XFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Icon(
              _getFileIcon(file),
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                file.name,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              onPressed: () {
                setState(() {
                  selectedFiles.remove(file);
                  widget.onFilesChanged
                      ?.call(selectedFiles); // Notify parent about changes
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(XFile file) {
    final String extension = file.name.split('.').last;
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.insert_drive_file;
    }
  }
}
