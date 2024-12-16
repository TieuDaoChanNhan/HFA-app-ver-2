import 'package:flutter/material.dart';

class UserRequestListtile extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final String role;
  final VoidCallback? onTap;
  final VoidCallback? onClear; // Callback cho nút xóa đầu tiên
  final VoidCallback? onDone; // Callback cho nút xóa thứ hai

  const UserRequestListtile({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.onTap,
    required this.role,
    required this.onClear,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize:
            MainAxisSize.min, // Đảm bảo hàng không chiếm quá nhiều không gian
        children: [
          IconButton(
            onPressed: onDone,
            icon: Icon(
              Icons.done, // Ví dụ thay đổi biểu tượng
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
