import 'package:flutter/material.dart';
import 'package:information_dam/navigation.dart';

AppBar customAppBar(String title, {required bool hasInfoButton, required BuildContext context, List<Widget>? actions}) => AppBar(
  centerTitle: true,
  title: Text(title),
  leading: hasInfoButton ? TextButton(onPressed: () => GoTo.infoScreen(context), child: const Text('info')) : null,
  actions: actions,
);

TextField customTextField({required TextEditingController controller, String? hintText, obscureText = false, outlineField = false}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(border: outlineField ? const OutlineInputBorder() : null, hintText: hintText),
    textAlign: TextAlign.center,
  );
}
