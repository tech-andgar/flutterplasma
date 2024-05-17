import 'package:flutter/material.dart';
import 'package:sa3_liquid/sa3_liquid.dart';

class OtherPlasma2 extends StatelessWidget {
  const OtherPlasma2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff6d1678),
            Color(0xff011c2c),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: const PlasmaRenderer(
        type: PlasmaType.circle,
        particles: 10,
        color: Color(0x4423b9e4),
        blur: 0.4,
        size: 1,
        speed: 6,
        offset: 0,
        blendMode: BlendMode.plus,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 0,
        child: PlasmaRenderer(
          type: PlasmaType.circle,
          particles: 10,
          color: Color(0x44b623e4),
          blur: 0.4,
          size: 1,
          speed: 5.16,
          offset: 0,
          blendMode: BlendMode.plus,
          variation1: 0.38,
          variation2: 0.48,
          variation3: 0,
          rotation: 0,
          child: PlasmaRenderer(
            type: PlasmaType.circle,
            particles: 3,
            color: Color(0x4423c1e4),
            blur: 0.4,
            size: 1,
            speed: 6.48,
            offset: 0,
            blendMode: BlendMode.plus,
            variation1: 0.82,
            variation2: 0.88,
            variation3: 0,
            rotation: 0,
          ),
        ),
      ),
    );
  }
}
