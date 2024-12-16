import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/profile/page/info_doctor.dart';

class ListDoctor extends StatelessWidget {
  ListDoctor({super.key});

  final int num_doctor = 4;

  final List<String> email = [
    "sample@gmail.com",
    "sample@gmail.com",
    "sample@gmail.com",
    "sample@gmail.com",
    "sample@gmail.com",
  ];
  final List<String> mobile = [
    "+84 123456789",
    "+84 123456789",
    "+84 123456789",
    "+84 123456789",
    "+84 123456789",
  ];
  List<String> degree = [
    "Bác sĩ",
    "Cử nhân",
    "Dược sĩ",
    "Bác sĩ chuyên khoa I",
    "Bác sĩ chuyên khoa I",
    "Bác sĩ chuyên khoa I",
  ];
  List<String> department = [
    "Khoa tim mạch",
    "Khoa thần kinh trung ương",
    "Khoa cấp cứu",
    "Khoa nội tiết",
    "Khoa nội tiết",
    "Khoa nội tiết",
  ];
  List<String> trunc = [
    "BS",
    "CN",
    "DS",
    "CK1",
    "CK1",
    "CK1",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách chuyên gia y tế",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        actions: [
          Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Divider(
                  height: 1,
                ),
                search_bar(context),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('isDoctor', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: snapshot.data!.docs.map((doc) {
                              return doctor(
                                  context,
                                  doc['photourl'],
                                  doc['name'],
                                  doc['id'],
                                  doc['rating'] == null
                                      ? 0.0
                                      : doc['rating'].toDouble(),
                                  doc['email'],
                                  doc['phoneNumber'],
                                  0
                                  // snapshot.data!.docs.indexOf(doc),
                                  );
                            }).toList(),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "Xem thêm ${num_doctor - 4} chuyên gia",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget doctor(BuildContext context, String image, String name, String id,
      double rate, String email, String mobile, int? index) {
    return GestureDetector(
      onTap: () {
        // add(context, index);
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        "A",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              id,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              trunc[index!].toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => InfoDoctor(
                              ten: name,
                              rate: rate,
                              id: id,
                              email: email,
                              mobile: mobile,
                              degree: degree[index],
                              department: department[index],
                            ));
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  // void add(BuildContext context, int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: 10),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width - 100,
  //                 child: Text(
  //                   "Thêm chuyên gia y tế",
  //                   style: TextStyle(
  //                     color: Theme.of(context).colorScheme.onSurface,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 24,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 24),
  //                 child: Column(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 16,
  //                         vertical: 4,
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(14),
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: Theme.of(context)
  //                                   .colorScheme
  //                                   .primaryContainer,
  //                             ),
  //                             child: Text(
  //                               "A",
  //                               style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Theme.of(context)
  //                                     .colorScheme
  //                                     .onPrimaryContainer,
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(
  //                             width: 12,
  //                           ),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 name[index],
  //                                 style: TextStyle(
  //                                   color:
  //                                       Theme.of(context).colorScheme.onSurface,
  //                                   fontSize: 16,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 id[index],
  //                                 style: TextStyle(
  //                                   color: Theme.of(context)
  //                                       .colorScheme
  //                                       .onSurfaceVariant,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 30,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             elevation: 0,
  //                             backgroundColor: Colors.transparent,
  //                           ),
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                           child: Text(
  //                             "Hủy",
  //                             style: TextStyle(
  //                                 color: Theme.of(context).colorScheme.error,
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                         ),
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             elevation: 0,
  //                             backgroundColor: Colors.transparent,
  //                           ),
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                           child: Text(
  //                             "Xác nhận",
  //                             style: TextStyle(
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget search_bar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextField(
        controller: TextEditingController(),
        decoration: InputDecoration(
          hintText: "Tìm chuyên gia y tế",
          prefixIcon: Icon(
            Icons.search,
            size: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
