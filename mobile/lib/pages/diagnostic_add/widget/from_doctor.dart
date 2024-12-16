import 'package:flutter/material.dart';

class FromDoctor extends StatefulWidget {
  final String doctorname;

  const FromDoctor({
    super.key,
    required this.doctorname,
  });

  @override
  State<FromDoctor> createState() => FromDoctorState();
}

class FromDoctorState extends State<FromDoctor> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64,
        // width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(4),
        //   border: Border.all(
        //     width: 1,
        //   ),
        // ),
        child: Row(
          children: [
            Image.asset('assets/images/HFA_small_icon.png'),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Chẩn đoán từ ${widget.doctorname}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Tạo bởi nền tảng HFA',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
