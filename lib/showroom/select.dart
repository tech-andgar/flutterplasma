import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import 'gesture_detector_with_click_hover.dart';

class PropertySelect extends StatelessWidget {
  const PropertySelect({
    required this.onChanged,
    required this.value,
    required this.options,
    super.key,
  });
  final Function(String?) onChanged;
  final String value;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: value,
          style: whiteRegular,
          dropdownColor: '#555555'.toColor(),
          items: _buildDropdownEntries(),
          onChanged: onChanged,
        ),
        MyIconButton(
          icon: Icons.navigate_before,
          onPressed: () => _nextOption(-1),
        ),
        MyIconButton(
          icon: Icons.navigate_next,
          onPressed: () => _nextOption(1),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownEntries() {
    return options.map((option) {
      return DropdownMenuItem(
        value: option,
        child: Text(option),
      );
    }).toList();
  }

  void _nextOption(int delta) {
    final sortedOptions = options;
    var index = sortedOptions.indexWhere((entry) => entry == value) + delta;

    if (index == sortedOptions.length) {
      index = 0;
    }

    if (index == -1) {
      index = sortedOptions.length - 1;
    }

    onChanged(sortedOptions[index]);
  }
}

TextStyle whiteRegular =
    const TextStyle(fontFamily: 'Work Sans', color: Colors.white, fontSize: 16);

class MyIconButton extends StatelessWidget {
  const MyIconButton({required this.icon, required this.onPressed, super.key});
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetectorWithClickHover(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}
