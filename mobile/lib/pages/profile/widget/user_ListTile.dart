import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health_for_all/common/API/firebase_API.dart';

class UserListTile extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final String collection;
  final String id;
  final String fieldName;
  final String valueToRemove;

  const UserListTile({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    required this.collection,
    required this.id,
    required this.fieldName,
    required this.valueToRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(description),
      trailing: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.error,
        ),
        onPressed: () async {
          try {
            EasyLoading.show(status: "Đang xử lí...");
            final success = await FirebaseApi.removeValueFromArrayField(
              collection,
              id,
              fieldName,
              valueToRemove,
            );

            final message = success
                ? 'Value removed successfully'
                : 'Failed to remove value';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error occurred: $e')),
            );
          } finally {
            EasyLoading.dismiss();
          }
        },
      ),
      onTap: onTap,
    );
  }
}
