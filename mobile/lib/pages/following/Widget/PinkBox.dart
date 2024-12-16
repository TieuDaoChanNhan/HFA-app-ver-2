import 'package:flutter/material.dart';
import 'package:health_for_all/common/entities/user.dart';

class Pinkbox extends StatelessWidget {
  final UserData user;
  final String role;
  final String alarmCount;
  final String time;
  const Pinkbox({
    super.key,
    required this.user,
    required this.role,
    required this.alarmCount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromRGBO(255, 216, 228, 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(user.photourl!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Chưa cập nhật tên',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    if (user.gender != null)
                      Text(
                        user.gender!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (user.gender != null) const SizedBox(width: 12),
                    Text(
                      user.age != 0 ? "${user.age} tuổi" : 'Chưa cập nhật tuổi',
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
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
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
                    role,
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
                      label: Text(alarmCount),
                      largeSize: 16,
                      backgroundColor: alarmCount == '0'
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.error,
                    ),
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
