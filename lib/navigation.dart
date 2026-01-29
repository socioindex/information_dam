import 'package:flutter/material.dart';
import 'package:information_dam/ui/create_article_screen.dart';
import 'package:information_dam/ui/info_page.dart';


class GoTo {
  static infoScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InfoPage()));
  }
  static createPostScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateArticleScreen()));
  }
}
