import 'package:flutter/material.dart';

class CmButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Widget child;

  const CmButton({
    super.key,
    this.color = Colors.blue, // color por defecto
    required this.onPressed,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: child
    );
  }
}
