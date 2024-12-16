import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/enum/type_diagnostic_status.dart';
import 'package:health_for_all/pages/diagnostic/controller.dart';
import 'package:health_for_all/pages/diagnostic/screen/diagnostic_screen.dart';

class DiagnosticPage extends StatelessWidget {
  final UserData user;
  DiagnosticPage({super.key, required this.user});
  final controller = Get.find<DiagnosticController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Chẩn đoán'),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/HFA_small_icon.png',
                ),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa đọc',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Thêm thuộc tính này để cắt ngắn văn bản nếu quá dài
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Obx(() {
                          if (controller.state.unread.value > 0) {
                            return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                      controller.state.unread.value.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                      )),
                                ));
                          } else {
                            return Container();
                          }
                        })
                      ]),
                ),
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Quan trọng',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Thêm thuộc tính này để cắt ngắn văn bản nếu quá dài
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Obx(() {
                          if (controller.state.importance.value > 0) {
                            return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                      controller.state.importance.value
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                      )),
                                ));
                          } else {
                            return Container();
                          }
                        })
                      ]),
                ),
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đã đọc',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Thêm thuộc tính này để cắt ngắn văn bản nếu quá dài
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Obx(() {
                          if (controller.state.read.value > 0) {
                            return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                      controller.state.read.value.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                      )),
                                ));
                          } else {
                            return Container();
                          }
                        })
                      ]),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DiagnosticScreen(
                user: user,
                status: TypeDiagnosticStatus.unread,
              ),
              DiagnosticScreen(
                user: user,
                status: TypeDiagnosticStatus.importance,
              ),
              DiagnosticScreen(
                user: user,
                status: TypeDiagnosticStatus.read,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
