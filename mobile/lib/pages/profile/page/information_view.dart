// information_view.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final controller = Get.find<ProfileController>();
  bool isEditing = false;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(text: "+84 ");
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();

  String originalId = '';
  String originalName = '';
  String originalEmail = '';
  String originalPhone = '';
  String originalDob = '';
  String originalGender = '';

  @override
  void initState() {
    super.initState();
    controller.appController.getProfile();
    log(controller.appController.state.profile.value.toString());
    // Initialize the controllers with current values if available
    if (controller.appController.state.profile.value != null) {
      _idController.text =
          controller.appController.state.profile.value!.id.toString();
      _nameController.text =
          controller.appController.state.profile.value!.name ?? '';
      _emailController.text =
          controller.appController.state.profile.value!.email ?? '';
      _phoneController.text =
          "+84 ${controller.appController.state.profile.value!.phoneNumber ?? ''}";
      _dobController.text =
          controller.appController.state.profile.value!.dateOfBirth ??
              DateTime.now().toString();
      _genderController.text =
          controller.appController.state.profile.value!.gender ?? '';

      // Store the original values
      originalId = controller.appController.state.profile.value!.id ?? '';
      originalName = controller.appController.state.profile.value!.name ?? '';
      originalEmail = controller.appController.state.profile.value!.email ?? '';
      originalPhone =
          controller.appController.state.profile.value!.phoneNumber ?? '';
      originalDob =
          controller.appController.state.profile.value!.dateOfBirth ?? '';
      originalGender =
          controller.appController.state.profile.value!.gender ?? '';
    }

    // Add listeners to update controller state on change
    _idController.addListener(() {
      controller.state.id.value = _idController.text;
    });
    _nameController.addListener(() {
      controller.state.name.value = _nameController.text;
    });
    _emailController.addListener(() {
      controller.state.email.value = _emailController.text;
    });
    _phoneController.addListener(() {
      if (!_phoneController.text.startsWith("+84 ")) {
        _phoneController.text = "+84 ";
        _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneController.text.length));
      } else {
        controller.state.phoneNumber.value = _phoneController.text.substring(3);
      }
    });
    _dobController.addListener(() {
      controller.state.dateOfBirth.value = _dobController.text;
    });
    _genderController.addListener(() {
      controller.state.gender.value = _genderController.text;
    });

    // Add focus listeners to rebuild the widget when focus changes
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
    _dobFocusNode.addListener(() {
      setState(() {});
    });
    _genderFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _dobFocusNode.dispose();
    _genderFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.appController.state.profile.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity, // Full width
                    height: 180, // Adjust height as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50, // Adjust radius as needed
                          backgroundImage: NetworkImage(
                            controller.appController.state.profile.value!
                                .photourl!, // Replace with your image URL
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.appController.state.profile.value!
                                  .name!, // Replace with dynamic value if needed
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isEditing) ...[
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                controller.state.id.value = _idController.text;
                                controller.state.name.value =
                                    _nameController.text;
                                controller.state.email.value =
                                    _emailController.text;
                                controller.state.phoneNumber.value =
                                    _phoneController.text.substring(3);
                                controller.state.dateOfBirth.value =
                                    _dobController.text;
                                controller.state.gender.value =
                                    _genderController.text;
                                originalId = controller.state.id.value;
                                originalName = controller.state.name.value;
                                originalEmail = controller.state.email.value;
                                originalPhone =
                                    controller.state.phoneNumber.value;
                                originalDob =
                                    controller.state.dateOfBirth.value;
                                originalGender = controller.state.gender.value;
                                controller.appController.state.profile.value!
                                    .name = controller.state.name.value;
                                controller.appController.state.profile.value!
                                    .email = controller.state.email.value;
                                controller.appController.state.profile.value!
                                        .phoneNumber =
                                    controller.state.phoneNumber.value;
                                controller.appController.state.profile.value!
                                        .dateOfBirth =
                                    controller.state.dateOfBirth.value;
                                controller.appController.state.profile.value!
                                    .gender = controller.state.gender.value;
                                controller.appController.state.profile.value
                                    .toString();

                                // Update the profile in the database
                                isEditing = false; // Exit editing mode
                              });
                              controller.updateUserDataById(
                                  controller
                                      .appController.state.profile.value!.id
                                      .toString(),
                                  controller
                                      .appController.state.profile.value!);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                // Reset the values to original
                                _idController.text = originalId;
                                _nameController.text = originalName;
                                _emailController.text = originalEmail;
                                _phoneController.text = "+84$originalPhone";
                                _dobController.text = originalDob;
                                _genderController.text = originalGender;
                                isEditing = false; // Exit editing mode
                              });
                            },
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditing = true; // Enter editing mode
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.perm_identity),
                    title: const Text('Mã người dùng'),
                    subtitle:
                        Text(controller.appController.state.profile.value!.id!),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: controller
                                .appController.state.profile.value!.id!));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Đã lưu mã người dùng')));
                      },
                    ),
                  )),
              _buildListTile(
                icon: Icons.person_outlined,
                title: 'Họ tên',
                controller: _nameController,
                focusNode: _nameFocusNode,
                isEditing: isEditing,
                onCopy: () {
                  Clipboard.setData(
                      ClipboardData(text: controller.state.name.value));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu họ tên')));
                },
              ),
              _buildListTile(
                icon: Icons.email_outlined,
                title: 'Email',
                controller: _emailController,
                focusNode: _emailFocusNode,
                isEditing: isEditing,
                onCopy: () {
                  Clipboard.setData(
                      ClipboardData(text: controller.state.email.value));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu email')));
                },
              ),
              _buildListTile(
                icon: Icons.phone_outlined,
                title: 'Số điện thoại',
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                isEditing: isEditing,
                onCopy: () {},
              ),
              _buildListTile(
                icon: Icons.calendar_month_outlined,
                title: 'Ngày sinh',
                controller: _dobController,
                focusNode: _dobFocusNode,
                isEditing: isEditing,
                onCopy: () {},
              ),
              _buildListTile(
                icon: Icons.accessibility,
                title: 'Giới tính',
                controller: _genderController,
                focusNode: _genderFocusNode,
                isEditing: isEditing,
                onCopy: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isEditing,
    required VoidCallback onCopy,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: isEditing ? null : Icon(icon),
      title: isEditing
          ? TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: Icon(icon),
                labelText: title,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                suffixIcon: focusNode.hasFocus
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          controller.text = "+84 "; // Ensure +84 remains
                          setState(() {});
                        },
                      )
                    : null,
              ),
            )
          : Text(title),
      subtitle: isEditing ? null : Text(controller.text),
      trailing: isEditing
          ? null
          : (title == "Số điện thoại"
              ? const Icon(Icons.phone_forwarded)
              : (title == "Ngày sinh" || title == "Giới tính"
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: onCopy,
                    ))),
    );
  }
}
