import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import '../demo/fancy_plasma1/fancy_widgets1.dart';
import '../demo/fancy_plasma1/other_plasma1.dart';
import '../demo/fancy_plasma1/other_plasma2.dart';
import '../demo/fancy_plasma2/fancy_plasma2.dart';
import '../demo/intro/large_text.dart';
import '../demo/layout/layout_a.dart';
import '../demo/layout/layout_b.dart';
import '../demo/layout/layout_c.dart';
import '../demo/layout/layout_d.dart';
import '../demo/layout/layout_wall.dart';
import '../demo/outro/outro.dart';
import '../demo/sky/dash.dart';
import '../demo/sky/sky.dart';
import '../demo/stars/stars.dart';
import '../showroom/select.dart';

class ShowRoom extends StatefulWidget {
  const ShowRoom({required this.index, required this.onIndexChange, super.key});
  final int index;
  final Function(int) onIndexChange;

  @override
  State<ShowRoom> createState() => _ShowRoomState();
}

class _ShowRoomState extends State<ShowRoom> {
  Widget displayedWidget = _introText();
  String selectedItem = 'Pick a widget here...';

  void changeWidgetFromOutside(int index) {
    setState(() {
      final allWidgets = widgets.entries.toList();
      try {
        selectedItem = allWidgets[widget.index].key;
        displayedWidget = allWidgets[widget.index].value();
      } catch (e) {
        selectedItem = allWidgets[0].key;
        displayedWidget = allWidgets[0].value();
      }
    });
  }

  void changeWidgetInternally(String key) {
    final allWidgets = widgets.entries.toList();
    final index = allWidgets.indexWhere((element) => element.key == key);
    widget.onIndexChange(index);
  }

  @override
  void initState() {
    changeWidgetFromOutside(widget.index);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ShowRoom oldWidget) {
    changeWidgetFromOutside(widget.index);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final smallScreen = constraints.maxWidth < 700;
        final spacing = smallScreen ? 0.0 : 32.0;

        return Container(
          color: '#333333'.toColor(),
          child: Column(
            children: [
              Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: spacing),
                color: Colors.black.withOpacity(0.3),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: smallScreen ? 16 : 0),
                      child: LargeText(
                        'ShowRoom',
                        bold: true,
                        textSize: smallScreen ? 14 : 18,
                      ),
                    ),
                    const Spacer(),
                    PropertySelect(
                      value: selectedItem,
                      onChanged: (newValue) {
                        changeWidgetInternally(newValue!);
                      },
                      options: widgets.keys.toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing),
                    child: displayedWidget,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Map<String, Widget Function()> widgets = {
  'Pick a widget here...': _introText,
  'Layout A': () => _square(const LayoutA()),
  'Layout B': () => _square(const LayoutB()),
  'Layout C': () => _square(const LayoutC()),
  'Layout D': () => _square(const LayoutD()),
  'Layout Wall': () => const LayoutWall(),
  'Plasma 1 (blue)': () =>
      FancyPlasmaWidget1(color: Colors.blue.withOpacity(0.4)),
  'Plasma 1 (red)': () =>
      FancyPlasmaWidget1(color: Colors.red.withOpacity(0.4)),
  'Plasma 1 (yellow)': () =>
      FancyPlasmaWidget1(color: Colors.yellow.withOpacity(0.4)),
  'Plasma 1 (green)': () =>
      FancyPlasmaWidget1(color: Colors.green.withOpacity(0.4)),
  'Plasma 2 (blue)': () =>
      FancyPlasmaWidget2(color: Colors.blue.withOpacity(0.4)),
  'Plasma 2 (red)': () =>
      FancyPlasmaWidget2(color: Colors.red.withOpacity(0.4)),
  'Plasma 2 (yellow)': () =>
      FancyPlasmaWidget2(color: Colors.yellow.withOpacity(0.4)),
  'Plasma 2 (green)': () =>
      FancyPlasmaWidget2(color: Colors.green.withOpacity(0.4)),
  'Plasma 3': () => const OtherPlasma1(),
  'Plasma 4': () => const OtherPlasma2(),
  'Plasma 5': () => const FancyPlasma2(),
  'Sky': () => const Sky(),
  'Dash': () => const DashAnimation(),
  'Stars': () => const Stars(),
  'Outro': () => const Outro(),
};

Widget _square(Widget child) => AspectRatio(
      aspectRatio: 1,
      child: child,
    );

Widget _introText() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: LargeText(
      'Use the select box on the top right to navigate between screens.',
      textSize: 16,
    ),
  );
}

Widget Function() stringToWidgetBuilder(String string) {
  return widgets.entries.firstWhere((w) => w.key == string).value;
}
