import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/components/square_tile.dart';

import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  SignInPage({super.key});

  @override
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              Image.asset(
                'assets/images/HFA.png',
                height: 200,
              ),

              const SizedBox(height: 25),

              //Health For All
              Text(
                "Health For All",
                style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 25),

              //Welcome
              Text(
                "Chào mừng!",
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              //Login to continue
              Text(
                "Xin hãy đăng nhập để tiếp tục",
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 100),

              //google sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  SquareTile(
                      onTap: () => controller.handleSignIn(),
                      imagePath: 'assets/images/google.png'),
                ],
              ),
              const SizedBox(height: 20),

              //apple sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //apple button
                  SquareTile(
                      onTap: () {}, imagePath: 'assets/images/apple.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
