import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import 'audio.dart';
import 'effects/shatter.dart';
import 'fancy_plasma1/fancy_plasma1.dart';
import 'fancy_plasma2/fancy_plasma2.dart';
import 'intro/intro.dart';
import 'layout/layout_wall.dart';
import 'outro/outro.dart';
import 'sky/sky.dart';
import 'stars/stars.dart';
import 'startpage/start_page.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({
    required this.onComplete,
    required this.showCredits,
    super.key,
  });
  final VoidCallback onComplete;
  final bool showCredits;

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer('assets/assets/music.mp3');

  CustomAnimationControl control = CustomAnimationControl.stop;

  List<Widget> widgets = <Widget>[];

  @override
  void initState() {
    widgets = <Widget>[
      Container(),
      const Intro(),
      const FancyPlasma1(),
      const LayoutWall(),
      const FancyPlasma2(),
      const Sky(),
      const Stars(),
      Container(),
      Outro(onComplete: widget.onComplete),
    ];

    super.initState();
  }

  Future<void> _start(Function shatterFn) async {
    if (kIsWeb) {
      await _audioPlayer.play();

      while (true) {
        final position = _audioPlayer.position;
        if (position > 0.seconds) {
          setState(() => control = CustomAnimationControl.playFromStart);
          shatterFn();
          break;
        }
        await 1.milliseconds.delay;
      }
    } else {
      setState(() => control = CustomAnimationControl.playFromStart);
      shatterFn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tween = _createTween(widget.showCredits);

    return Scaffold(
      body: CustomAnimation<TimelineValue<_P>>(
        control: control,
        tween: tween,
        duration: tween.duration,
        builder: (context, child, value) {
          final widgetIndex = value.get<int>(_P.widgetIndex);
          return Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: widgets[widgetIndex],
                ),
                if (widgetIndex <= 1)
                  Positioned.fill(
                    child: ShatterScene(
                      builder: (context, shatterFn) =>
                          StartPage(pressedStart: () => _start(shatterFn)),
                    ),
                  ),
              ],
            ),
          );
        },
        animationStatusListener: (status) {
          if (status == AnimationStatus.completed) {
            _audioPlayer.pause();
          }
        },
      ),
    );
  }
}

enum _P { widgetIndex }

TimelineTween<_P> _createTween(bool withCredits) {
  final tween = TimelineTween<_P>();

  final intro = tween
      .addScene(begin: 0.milliseconds, duration: 605.milliseconds)
      .animate(_P.widgetIndex, tween: ConstantTween<int>(0));

  final message = intro
      .addSubsequentScene(duration: musicUnitMs.milliseconds)
      .animate(_P.widgetIndex, tween: ConstantTween<int>(1));

  final plasmas = tween
      .addScene(
        begin: 13068.milliseconds,
        duration: (2 * musicUnitMs).round().milliseconds,
      )
      .animate(_P.widgetIndex, tween: ConstantTween<int>(2));

  final layoutWall = tween
      .addScene(
        begin: 25414.milliseconds,
        duration: (2 * musicUnitMs).round().milliseconds,
      )
      .animate(_P.widgetIndex, tween: ConstantTween<int>(3));

  final plasmaComposition = tween
      .addScene(
        begin: 37728.milliseconds,
        duration: (2 * musicUnitMs).round().milliseconds,
      )
      .animate(_P.widgetIndex, tween: ConstantTween<int>(4));

  final sky = plasmaComposition
      .addSubsequentScene(duration: musicUnitMs.milliseconds)
      .animate(_P.widgetIndex, tween: ConstantTween<int>(5));

  final space = sky
      .addSubsequentScene(duration: musicUnitMs.milliseconds)
      .animate(_P.widgetIndex, tween: ConstantTween<int>(6));

  final dark = space
      .addSubsequentScene(duration: 2000.milliseconds)
      .animate(_P.widgetIndex, tween: ConstantTween<int>(7));

  if (withCredits) {
    final outro = tween
        .addScene(begin: 66275.milliseconds, end: 91532.milliseconds)
        .animate(_P.widgetIndex, tween: ConstantTween<int>(8));

    final end = tween.addScene(begin: 94.seconds, duration: 1.milliseconds);
  }

  return tween;
}

const musicUnitMs = 6165;
