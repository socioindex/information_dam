import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColoursPage extends ConsumerStatefulWidget {
  const ColoursPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ColoursPageState();
}

class _ColoursPageState extends ConsumerState<ColoursPage> {
  Color goodColor = Colors.green;
  Color badColor = Colors.red;

  _showColorDialog(bool isGood) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pick colors!')),
      body: Column(
        children: [
          Column(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("pick good color")),
              Card(color: goodColor),
            ],
          ),
          Column(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('pick bad color')),
              Card(color: badColor),
            ],
          ),
        ],
      ),
    );
  }
}
