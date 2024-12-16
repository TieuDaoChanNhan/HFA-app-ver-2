import 'package:flutter/material.dart';

class InfoDoctor extends StatefulWidget {
  final String ten;
  final double rate;
  final String id;
  final String email;
  final String mobile;
  final String degree;
  final String department;
  const InfoDoctor(
      {super.key,
      required this.ten,
      required this.rate,
      required this.id,
      required this.email,
      required this.mobile,
      required this.degree,
      required this.department});

  @override
  State<InfoDoctor> createState() => _InfoDoctorState();
}

class _InfoDoctorState extends State<InfoDoctor> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Thông tin chuyên gia y tế"),
            actions: [
              Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(
                width: 12,
              ),
            ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Thông tin",
                ),
                Tab(
                  text: "Đánh giá",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              info(),
              rate(),
            ],
          )),
    );
  }

  Widget info() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(9),
                    child: Icon(
                      Icons.add_task,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/images/3d_avatar_24.png"),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.ten,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.degree,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.department,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              small_box(
                Icon(
                  Icons.numbers,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                "Mã người dùng",
                widget.id,
                Icon(
                  Icons.content_copy,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              small_box(
                Icon(
                  Icons.person_outline,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                "Họ tên",
                widget.ten,
                Icon(
                  Icons.content_copy,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              small_box(
                Icon(
                  Icons.email_outlined,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                "Email",
                widget.email,
                Icon(
                  Icons.content_copy,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              small_box(
                Icon(
                  Icons.phone_outlined,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                "Số điện thoại",
                widget.mobile,
                Icon(
                  Icons.phone_forwarded,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget small_box(Icon lead, String head, String item, Icon trail) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    lead,
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          head,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          item,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: trail),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget rate() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                message("Nguyễn Văn B", "06:00", "29/07/2024", 5.0, "Rất tốt",
                    "Bác sỹ tư vấn và chẩn đoán rất tốt"),
                message("Nguyễn Văn B", "06:00", "29/07/2024", 5.0, "Rất tốt",
                    "Bác sỹ tư vấn và chẩn đoán rất tốt"),
                message("Nguyễn Văn B", "06:00", "29/07/2024", 5.0, "Rất tốt",
                    "Bác sỹ tư vấn và chẩn đoán rất tốt"),
              ],
            ),
          ),
        ),
        rating(),
      ],
    );
  }

  Widget rating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.rate.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              for (int i = 1; i <= 5; i++)
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "(10)",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
                const SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
                const SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
                const SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
                const SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    // Define the onTap behavior if needed, or remove the onTap if not required
                  },
                  readOnly: false,
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.text_fields,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget message(String name, String time, String date, double rate,
      String emotion, String comment) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.reviews_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  seperator(Colors.black),
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                  seperator(Colors.black),
                  Text(
                    "$time, $date",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    emotion,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  seperator(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    rate.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  seperator(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  for (int i = 1; i <= 5; i++)
                    Icon(
                      Icons.star,
                      size: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    comment,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget seperator(Color color) {
    return Row(
      children: [
        const SizedBox(
          width: 6,
        ),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
