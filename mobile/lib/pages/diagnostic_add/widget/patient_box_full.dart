import 'package:flutter/material.dart';

class PatientBoxFull extends StatefulWidget {
  final Color boxcolor;
  final String avapath;
  final String name;
  final String gender;
  final String age;
  final String time;
  final String person;
  final String warning;

  const PatientBoxFull(
      {super.key,
      required this.boxcolor,
      required this.avapath,
      required this.name,
      required this.gender,
      required this.age,
      required this.time,
      required this.person,
      required this.warning});

  @override
  State<PatientBoxFull> createState() => PatientBoxFullState();
}

class PatientBoxFullState extends State<PatientBoxFull> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.boxcolor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 1,
              blurRadius: 2,
            )
          ]),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(widget.avapath),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.gender,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.age,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Text(
                      ' tuổi',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Cập nhật: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 120,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                ),
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: SizedBox(
                  width: 88,
                  height: 16,
                  child: Text(
                    widget.person,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 120,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                ),
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cảnh báo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Badge(
                      // child: Text("2"),
                      label: Text(widget.warning),
                      largeSize: 16,
                      backgroundColor: widget.warning == '0'
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.error,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
