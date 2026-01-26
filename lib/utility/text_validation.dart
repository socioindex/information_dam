import 'package:flutter/material.dart';

bool isValidTextValue(TextEditingController controller) {
  if (controller.text.trim() == "") {
    return false;
  } else {
    return true;
  }
}

String validTextValueReturner(TextEditingController controller) {
  return controller.text.trim();
}

Future<bool?> popUpLinkClick(BuildContext context, String url) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("you are about to go to $url"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('proceed'),
          ),
        ],
      );
    },
  );
}

//TODO check if link is harmful
bool isValidLink(TextEditingController controller) {
  final value = controller.text.trim();
  if (Uri.parse(value).isAbsolute) {
    return true;
  } else {
    return false;
  }
}
