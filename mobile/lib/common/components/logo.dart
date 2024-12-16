import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String imagePath;
  const Logo({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      child: Image.asset(imagePath, height: 40,),
    );
  }
}