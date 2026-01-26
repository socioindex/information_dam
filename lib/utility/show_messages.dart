import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void showAlertDialog(BuildContext context, String message) => showDialog(
  context: context,
  builder: (context) => AlertDialog(title: Text(message)),
);
