import 'package:flutter/material.dart';
import 'package:sa4_migration_kit/sa4_migration_kit.dart';
import 'package:supercharged/supercharged.dart';

import '../demo_screen.dart';
import 'flashes.dart';
import 'particles.dart';
import 'stars_background.dart';
import 'static_stars.dart';

class Stars extends StatelessWidget {
  const Stars({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = _createTween();

    return LayoutBuilder(
      builder: (context, constraints) {
        return LoopAnimation<TimelineValue<_P>>(
          tween: tween,
          duration: tween.duration,
          builder: (context, child, value) {
            return Stack(
              children: [
                const Positioned.fill(child: StarsBackground()),
                const Positioned.fill(child: StaticStars()),
                const Positioned.fill(child: Flashes()),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ParticlesPainter(value: value.get(_P.particles)),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Transform.scale(
                      scale: value.get(_P.scale),
                      child: Transform.rotate(
                        angle: value.get(_P.rotate),
                        child: FlutterLogo(size: constraints.maxWidth * 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

enum _P { scale, rotate, particles }

TimelineTween<_P> _createTween() {
  final tween = TimelineTween<_P>();

  tween
      .addScene(
        begin: (0.25 * musicUnitMs).round().milliseconds,
        end: (0.75 * musicUnitMs).round().milliseconds,
        curve: Curves.easeOutQuad,
      )
      .animate(_P.scale, tween: 0.01.tweenTo(1.5))
      .animate(_P.rotate, tween: (-70.6).tweenTo(0.0));

  tween
      .addScene(
        begin: 0.seconds,
        end: (1 * musicUnitMs).round().milliseconds,
      )
      .animate(_P.particles, tween: 0.0.tweenTo(3.0));

  return tween;
}
