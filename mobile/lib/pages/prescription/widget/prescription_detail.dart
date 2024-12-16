import 'package:flutter/material.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:image_picker/image_picker.dart';

class PrescriptionDetail extends StatefulWidget {
  final Prescription detail;
  final List<MedicineBase> med;
  final int order;

  const PrescriptionDetail({
    super.key,
    required this.detail,
    required this.med,
    required this.order,
  });

  @override
  State<PrescriptionDetail> createState() => _PrescriptionDetailState();
}

class _PrescriptionDetailState extends State<PrescriptionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đơn thuốc ${widget.order}",
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          Icon(
            Icons.medication_liquid_sharp,
            size: 34,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  name_prescription(),
                  list_tablet(),
                  time(),
                  file(),
                  note(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget name_prescription() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                "Tên đơn thuốc",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 56,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Icon(
                  Icons.medication_liquid_sharp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.detail.name!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget list_tablet() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                "Danh sách thuốc (${widget.med.length})",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tên thuốc",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        "Số lượng",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    ],
                  ),
                ),
                for (int i = 0; i < widget.med.length; i++)
                  medicine(widget.med[i].name!, widget.detail.medicineDose![i],
                      (i != widget.med.length - 1)),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget medicine(String name, String number, bool ok) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medication,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    number.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        if (ok)
          const Divider(
            height: 1,
          ),
      ],
    );
  }

  Widget time() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              "Thời gian",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.today_outlined,
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  Text(
                    "Từ ngày: ${widget.detail.startDate!}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Tới ngày: ${widget.detail.endDate!}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
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

  Widget file() {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              "File đính kèm",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: widget.detail.files != null && widget.detail.files!.isNotEmpty
              ? Column(
                  children: [
                    // Iterate over the files and display their names
                    for (var file in widget.detail.files!)
                      ListTile(
                        title: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getFileIcon(file),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                file.name
                                    .split('/')
                                    .last, // Show just the file name
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                      fontSize: 15
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // Implement file opening logic here if needed
                        },
                      ),
                  ],
                )
              : const Text(
                  "Không có file nào đính kèm."), // Message for no files
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget note() {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              "Ghi chú",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 56,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(
                Icons.edit_note_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Text(
                  widget.detail.note!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
            ],
          ),
        ),
        // _buildNoteField(context, Icons.edit_note, widget.noteController,
        //     width: MediaQuery.of(context).size.width - 32),
      ],
    );
  }

  Widget _buildNoteField(
      BuildContext context, IconData icon, TextEditingController controller,
      {required double width}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        readOnly: true,
      ),
    );
  }
}
