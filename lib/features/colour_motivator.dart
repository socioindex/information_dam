import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';



final colorChangerProvider = NotifierProvider.autoDispose<ColorChanger, ColorChoice>(ColorChanger.new);


class ColorChanger extends Notifier<ColorChoice> {
  @override
  build() {
    // Inside "build", we return the initial state of the counter.
    return ColorChoice(goodColor: Colors.green, badColor: Colors.red);
  }

  void changeGoodColor(Color color) {
    state.goodColor = color;
  }

  void changeBadColor(Color color) {
    state.badColor = color; 
  }
}


class ColorChoice {
  Color goodColor;
  Color badColor;
  ColorChoice({required this.goodColor, required this.badColor});

 
}
