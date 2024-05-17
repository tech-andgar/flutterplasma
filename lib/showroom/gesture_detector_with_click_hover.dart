import 'package:flutter/material.dart';

class GestureDetectorWithClickHover extends StatelessWidget {
  const GestureDetectorWithClickHover({
    required this.onTap,
    required this.child,
    super.key,
  });
  final GestureTapCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
