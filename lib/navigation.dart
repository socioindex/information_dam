import 'package:flutter/material.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/ui/article_screen.dart';
import 'package:information_dam/ui/create_article_screen.dart';
import 'package:information_dam/ui/info_page.dart';

import 'model/person.dart';

class GoTo {
  static infoScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InfoPage()));
  }

  static createPostScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateArticleScreen()));
  }

  static articleDetailScreen(BuildContext context, Article article, Person person, Function? unlockVoting) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticleScreen(article, person))).then((value) {
      if (unlockVoting != null) {
        unlockVoting(article.articleId);
      }
    });
  }
}
