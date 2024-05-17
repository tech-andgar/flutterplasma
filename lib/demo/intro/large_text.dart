import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  const LargeText(
    this.text, {
    required this.textSize,
    super.key,
    this.bold = false,
  });
  final String text;
  final bool bold;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Work Sans',
        color: Colors.white,
        fontSize: textSize,
        fontWeight: !bold ? FontWeight.w200 : FontWeight.w600,
      ),
    );
  }
}
