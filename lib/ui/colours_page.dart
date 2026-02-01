import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/colour_motivator.dart';

class ColoursPage extends ConsumerStatefulWidget {
  const ColoursPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ColoursPageState();
}

class _ColoursPageState extends ConsumerState<ColoursPage> {
  Color goodColor = Colors.green;
  Color badColor = Colors.red;
  Color pickerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    final ccEngine = ref.read(colorChangerProvider);
    goodColor = ccEngine.goodColor;
    badColor = ccEngine.badColor;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  _showColorDialog(bool isGood) {
    if (isGood) {
      pickerColor = goodColor;
    } else {
      pickerColor = badColor;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(pickerColor: pickerColor, onColorChanged: changeColor),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                if (isGood) {
                  setState(() => goodColor = pickerColor);
                  ref.read(colorChangerProvider.notifier).changeGoodColor(goodColor);
                } else {
                  setState(() => badColor = pickerColor);
                  ref.read(colorChangerProvider.notifier).changeBadColor(badColor);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pick colors!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showColorDialog(true);
                  },
                  child: const Text("pick good color"),
                ),
                GestureDetector(onTap: () => _showColorDialog(true), child: Card(color: goodColor, child: const SizedBox(height: 70, width: 120))),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showColorDialog(false);
                  },
                  child: const Text('pick bad color'),
                ),
                GestureDetector(onTap: () => _showColorDialog(false),child: Card(color: badColor, child: const SizedBox(height: 70, width: 120))),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
