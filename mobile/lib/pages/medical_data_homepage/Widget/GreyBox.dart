import 'package:flutter/material.dart';

class GreyBox extends StatefulWidget {
  final String title;
  final String iconpath;
  final String value;
  final String unit;
  final String time;
  final bool warning;

  const GreyBox(
      {super.key,
      required this.title,
      required this.iconpath,
      required this.value,
      required this.unit,
      required this.time,
      required this.warning});

  @override
  State<GreyBox> createState() => GreyBoxState();
}

class IconWarning extends StatelessWidget {
  final Icon icon;

  const IconWarning({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
    );
  }
}

class GreyBoxState extends State<GreyBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      // padding: Padding(

      // ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(243, 237, 247, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 2,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color.fromRGBO(29, 27, 32, 1),
                  ),
                ),
                const Icon(
                  Icons.open_in_new_outlined,
                  size: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Image.asset(widget.iconpath),
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(33, 0, 93, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.unit,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Color.fromRGBO(98, 91, 113, 1),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontSize: 12,
                  ),
                ),
                // if (widget.warning)
                // Icon(
                Icon(
                    size: 16,
                    Icons.priority_high_outlined,
                    color: widget.warning == true
                        ? const Color.fromRGBO(179, 38, 30, 1)
                        : const Color.fromRGBO(243, 237, 247, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
