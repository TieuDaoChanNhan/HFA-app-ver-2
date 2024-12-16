import 'package:flutter/material.dart';

class WhiteBox extends StatefulWidget {
  final String title;
  final IconData iconbox;
  final String text1;
  final String text2;
  final String value1;
  final String value2;

  const WhiteBox(
      {super.key,
      required this.title,
      required this.text1,
      required this.text2,
      required this.value1,
      required this.value2,
      required this.iconbox});

  @override
  State<WhiteBox> createState() => WhiteBoxState();
}

class WhiteBoxState extends State<WhiteBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width / 2 - 21,
      height: 106,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 1,
              blurRadius: 2,
            )
          ]),
      child: Column(
        children: [
          Row(
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
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                widget.iconbox,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.text1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(98, 91, 113, 1),
                            ),
                          ),
                        ),
                        Text(
                          widget.value1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(179, 38, 30, 1),
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.text2,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(98, 91, 113, 1),
                            ),
                          ),
                        ),
                        Text(
                          widget.value2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(98, 91, 113, 1),
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class WhiteBoxnoW extends StatefulWidget {
  final String title;
  final IconData iconbox;
  final String text1;
  final String value1;

  const WhiteBoxnoW(
      {super.key,
      required this.title,
      required this.text1,
      required this.value1,
      required this.iconbox});

  @override
  State<WhiteBoxnoW> createState() => WhiteBoxnoWState();
}

class WhiteBoxnoWState extends State<WhiteBoxnoW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width / 2 - 21,
      height: 106,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(255, 255, 255, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              spreadRadius: 1,
              blurRadius: 3,
            )
          ]),
      child: Column(
        children: [
          Row(
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
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                widget.iconbox,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 90,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.text1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(98, 91, 113, 1),
                        ),
                      ),
                    ),
                    Text(
                      widget.value1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(98, 91, 113, 1),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhiteBoxnoVal extends StatefulWidget {
  final String title;
  final IconData iconbox;
  final String text1;

  const WhiteBoxnoVal(
      {super.key,
      required this.title,
      required this.text1,
      required this.iconbox});

  @override
  State<WhiteBoxnoVal> createState() => WhiteBoxnoValState();
}

class WhiteBoxnoValState extends State<WhiteBoxnoVal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 21,
      height: 106,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(255, 255, 255, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              spreadRadius: 1,
              blurRadius: 3,
            )
          ]),
      child: Column(
        children: [
          Row(
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
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                widget.iconbox,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  widget.text1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(98, 91, 113, 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
