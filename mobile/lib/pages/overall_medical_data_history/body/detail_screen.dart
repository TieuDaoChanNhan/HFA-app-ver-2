import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    this.images,
    this.note,
  });

  final String? note;
  List<String>? images = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.edit_note,
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Ghi chú',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: TextEditingController(text: note ?? ''),
            readOnly: true,
            minLines: 3,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Ghi chú',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.attach_file,
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(
              width: 10,
            ),
            Text(
              'File đính kèm (${images?.length.toString() ?? "0"})',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            )
          ],
        ),
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: buildFileList(context))
      ],
    );
  }

  Widget buildFileList(BuildContext context) {
    if (images == null) {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(4),
        dashPattern: const [2, 3],
        color: Theme.of(context).colorScheme.outline,
        child: Container(
          width: 260,
          height: 30,
          alignment: Alignment.center,
          child: Text(
            'Chưa có file đính kèm',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: images?.length,
        itemBuilder: (context, index) {
          final String file = images![index];
          return buildFileItem(file, context);
        },
      );
    }
  }

  Widget buildFileItem(String file, BuildContext context) {
    final String fileName = path.basename(file);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(file),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  fileName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
