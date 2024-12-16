import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 40,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
              // offset: Offset(0, 3), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(100),
          color: imagePath == 'assets/images/google.png'
              ? Theme.of(context).colorScheme.surfaceContainerLow
              : Theme.of(context).colorScheme.onSurface,
        ),
        // child: Image.asset(imagePath, height: 40,),
        child: Row(
          children: [
            if (imagePath == 'assets/images/google.png')
              Image.asset(
                imagePath,
                height: 40,
              )
            else
              Image.asset(
                imagePath,
                height: 40,
              ),
            const SizedBox(
              width: 10,
            ),
            if (imagePath == 'assets/images/google.png')
              Text(
                "Đăng nhập bằng Google",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const Text(
                "Đăng nhập bằng Apple  ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
