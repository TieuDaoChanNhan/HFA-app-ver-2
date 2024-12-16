import 'package:flutter/material.dart';

class ComboBox extends StatefulWidget {
  final String leadingiconpath;
  final String time;
  final String title;
  final String value;
  final String unit;
  final IconButton? edit;
  final IconButton? upload;
  const ComboBox({
    super.key,
    required this.leadingiconpath,
    required this.title,
    required this.value,
    required this.unit,
    this.edit,
    this.upload,
    required this.time,
  });

  @override
  State<ComboBox> createState() => _ComboBoxState();
}

class IconWidget extends StatelessWidget {
  final Icon icon;

  const IconWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
    );
  }
}

void toggle() {}

class _ComboBoxState extends State<ComboBox> {
  final infor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                //Icon
                Image.asset(widget.leadingiconpath),

                // Tên chỉ số và giờ
                const SizedBox(width: 8),
                SizedBox(
                  height: 63,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Số đo
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.value,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.unit,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Chỉnh sửa
          IconWidgetRound(
              icon: Icon(
            Icons.edit_note,
            color: Theme.of(context).colorScheme.outline,
            size: 17,
          )),
          const SizedBox(
            width: 8,
          ),
          // Thêm file
          IconWidgetRound(
              icon: Icon(
            Icons.attach_file,
            color: Theme.of(context).colorScheme.outline,
            size: 17,
          )),
          const SizedBox(
            width: 15,
          ),
          // Comment
          IconWidgetRound(
              icon: Icon(
            Icons.comment,
            color: Theme.of(context).colorScheme.outline,
            size: 17,
          )),
          const SizedBox(
            width: 8,
          ),
          // Đánh giá
          const ImageWidgetRound(
            path: 'assets/images/xet_nghiem_mau.png',
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}

class IconWidgetRound extends StatelessWidget {
  final Icon icon;

  const IconWidgetRound({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: icon,
      ),
    );
  }
}

class ImageWidgetRound extends StatelessWidget {
  final String path;

  const ImageWidgetRound({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Image.asset(
          path,
          height: 17,
        ),
      ),
    );
  }
}
