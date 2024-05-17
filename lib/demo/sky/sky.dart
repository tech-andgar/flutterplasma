import 'package:flutter/material.dart';
import 'package:sa3_liquid/sa3_liquid.dart';
import 'package:sa4_migration_kit/sa4_migration_kit.dart';
import 'package:supercharged/supercharged.dart';

import '../demo_screen.dart';
import 'dash.dart';

class Sky extends StatelessWidget {
  const Sky({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = _createTween();

    return LayoutBuilder(
      builder: (context, constraints) {
        return LoopAnimation<TimelineValue<_P>>(
          tween: tween,
          duration: tween.duration,
          builder: (context, child, value) {
            final otherDashes = value.get<double>(_P.otherDashes);

            return Stack(
              children: [
                const Positioned.fill(child: SkyGradient()),
                const Positioned.fill(child: CloudsPlasma()),
                if (otherDashes > 0)
                  Positioned.fill(child: OtherDashes(otherDashes)),
                Positioned(
                  left: value.get<double>(_P.left1) * constraints.maxWidth,
                  top: value.get<double>(_P.top1) * constraints.maxHeight,
                  width: value.get<double>(_P.size1) * constraints.maxWidth,
                  height: value.get<double>(_P.size1) * constraints.maxWidth,
                  child: Transform.rotate(
                    angle: value.get(_P.rotate1),
                    child: const DashAnimation(),
                  ),
                ),
                const Positioned.fill(child: ForegroundCloudsPlasma()),
              ],
            );
          },
        );
      },
    );
  }
}

class OtherDashes extends StatelessWidget {
  const OtherDashes(this.otherDashes, {super.key});

  final double otherDashes;

  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<double>(
      tween: 0.0.tweenTo(1.0),
      duration: 300.milliseconds,
      builder: (context, child, value) {
        return CustomPaint(painter: MultiDashPainter(otherDashes, value));
      },
    );
  }
}

enum _P { left1, top1, size1, rotate1, otherDashes }

TimelineTween<_P> _createTween() {
  final tween = TimelineTween<_P>();

  tween
      .addScene(
        begin: (0.0 * musicUnitMs).round().milliseconds,
        end: (0.25 * musicUnitMs).round().milliseconds,
        curve: Curves.easeOut,
      )
      .animate(_P.left1, tween: 1.05.tweenTo(0.2))
      .animate(_P.top1, tween: 0.6.tweenTo(0.3))
      .animate(_P.size1, tween: 0.4.tweenTo(0.3));

  tween
      .addScene(
        begin: (0.25 * musicUnitMs).round().milliseconds,
        end: (0.5 * musicUnitMs).round().milliseconds,
        curve: Curves.easeInOut,
      )
      .animate(_P.left1, tween: 0.2.tweenTo(0.3))
      .animate(_P.top1, tween: 0.3.tweenTo(0.4))
      .animate(_P.size1, tween: 0.3.tweenTo(0.35));

  tween
      .addScene(
        begin: (0.5 * musicUnitMs).round().milliseconds,
        end: (0.75 * musicUnitMs).round().milliseconds,
        curve: Curves.easeInOut,
      )
      .animate(_P.left1, tween: 0.3.tweenTo(0.2))
      .animate(_P.top1, tween: 0.4.tweenTo(0.3))
      .animate(_P.size1, tween: 0.35.tweenTo(0.3));

  tween
      .addScene(
        begin: (0.50 * musicUnitMs).round().milliseconds,
        end: (1.0 * musicUnitMs).round().milliseconds,
        curve: Curves.easeOut,
      )
      .animate(_P.otherDashes, tween: 0.0.tweenTo(1.0));

  final fallIntoSwarm = tween
      .addScene(
        begin: (0.75 * musicUnitMs).round().milliseconds,
        end: (0.83 * musicUnitMs).round().milliseconds,
        curve: Curves.easeOut,
      )
      .animate(
        _P.rotate1,
        tween: 0.1.tweenTo(0.35),
        shiftEnd: -400.milliseconds,
        curve: Curves.easeInOut,
      )
      .animate(_P.left1, tween: 0.2.tweenTo(0.35))
      .animate(_P.top1, tween: 0.3.tweenTo(0.4))
      .animate(_P.size1, tween: 0.3.tweenTo(0.2));

  fallIntoSwarm
      .addSubsequentScene(duration: (0.17 * musicUnitMs).round().milliseconds)
      .animate(_P.top1, tween: 0.4.tweenTo(-0.8))
      .animate(_P.left1, tween: 0.35.tweenTo(0.25));

  tween.addScene(end: musicUnitMs.milliseconds, duration: 1.milliseconds);

  return tween;
}

class SkyGradient extends StatelessWidget {
  const SkyGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff214c8f),
            Color(0xff4999d9),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
    );
  }
}

class CloudsPlasma extends StatelessWidget {
  const CloudsPlasma({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlasmaRenderer(
      type: PlasmaType.bubbles,
      particles: 39,
      color: Color(0x44ffffff),
      blur: 0.55,
      size: 1.44,
      speed: 3.88,
      offset: 0,
      blendMode: BlendMode.srcOver,
      variation1: 0,
      variation2: 0,
      variation3: 0,
      rotation: 1.63,
    );
  }
}

class ForegroundCloudsPlasma extends StatelessWidget {
  const ForegroundCloudsPlasma({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlasmaRenderer(
      type: PlasmaType.bubbles,
      particles: 10,
      color: Color(0x66ffffff),
      blur: 0.55,
      size: 2.44,
      speed: 3.88,
      offset: 0,
      blendMode: BlendMode.srcOver,
      variation1: 0,
      variation2: 0,
      variation3: 0,
      rotation: 1.63,
    );
  }
}
