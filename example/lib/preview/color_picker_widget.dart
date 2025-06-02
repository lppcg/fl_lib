import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

class PreviewColorPickerWidget extends StatelessWidget {
  const PreviewColorPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Color Picker Preview')),
      body: Center(
        child: ColorPicker(color: UIs.colorSeed, onColorChanged: print),
      ),
    );
  }
}
