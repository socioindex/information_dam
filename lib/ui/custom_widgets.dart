import 'package:flutter/material.dart';
import 'package:information_dam/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar customAppBar(String title, {required bool hasInfoButton, required BuildContext context, List<Widget>? actions}) => AppBar(
  centerTitle: true,
  title: Text(title),
  leading: hasInfoButton
      ? Center(
          child: GestureDetector(onTap: () => GoTo.infoScreen(context), child: const Text('info')),
        )
      : null,
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

class ArticleStyles {
  static titleText(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  static urlButton(String url, BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("You are about to go to $url"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('OK'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('NO WAY'),
                ),
              ],
            );
          },
        ).then((value) async {
          if (value == true) {
            final Uri launderedUrl = Uri.parse(url);
            if (!await launchUrl(launderedUrl)) {
              throw Exception('Could not launch $url');
            }
          }
        });
      },
      child: Text(url, style: _urlStyle),
    ),
  );

  static TextStyle get _urlStyle => TextStyle(fontSize: 16);

  static contentText(String content) {
    return Text(content);
  }
}
