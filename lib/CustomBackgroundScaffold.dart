import 'package:flutter/material.dart';

class CustomBackgroundScaffold extends StatelessWidget {
  final Widget child;
  final String backgroundImage;

  const CustomBackgroundScaffold({
    Key? key,
    required this.child,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}
