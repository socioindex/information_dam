import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/articles/articles_controller.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/model/person.dart';
import 'package:information_dam/navigation.dart';
import 'package:information_dam/utility/error_loader.dart';

import '../features/authentication/auth_controller.dart';

//TODO custom colors
const Color kGoodColor = Colors.green;
const Color kBadColor = Colors.red;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Person _person;
  final List<String> _articlesViewed = [];

  void _unlockVoting(String articleId) {
    setState(() {
      _articlesViewed.add(articleId);
    });
  }

  @override
  void initState() {
    super.initState();
    _person = ref.read(personProvider)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "info") {
              GoTo.infoScreen(context);
            }
            if (value == "color") {}
            if (value == "out") {
              ref.read(authControllerProvider.notifier).signOut(context);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: "info", child: const Text('Info')),
              PopupMenuItem(value: "color", child: const Text('Color')),
              PopupMenuItem(value: "out", child: const Text('logOut(4testing)')),
            ];
          },
          child: const Text('options'),
        ),
        actions: [TextButton(onPressed: () => GoTo.createPostScreen(context), child: const Text("create"))],
        centerTitle: true,
        //TODO leading menu for info and stuff
        title: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text("This is your username"),
                children: [ElevatedButton(onPressed: Navigator.of(context).pop, child: const Text('ok'))],
              ),
            );
          },
          child: Text(_person.alias),
        ),
      ),
      body: ref
          .watch(articleFeedProvider)
          .when(
            data: (listOfArticles) {
              return ListView.builder(
                itemCount: listOfArticles.length,
                itemBuilder: (context, index) {
                  final article = listOfArticles[index];
                  return _articleCard(article);
                },
              );
            },
            error: (error, stackTrace) => ErrorPage(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  Widget _articleCard(Article article) {
    if (article.authorId == _person.uid) {
      return _authoredCard(article);
    }
    if (article.agreement.contains(_person.uid)) {
      return _votedCard(article, true);
    }
    if (article.disagreement.contains(_person.uid)) {
      return _votedCard(article, false);
    }

    if (_articlesViewed.contains(article.articleId)) {
      return _basicCard(
        article,
        locked: false,
        leading: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).disagree(article.articleId, _person.uid);
            if (article.score < 0) {
              ref.read(articlesControllerProvider.notifier).delete(article.articleId);
            }
          },
          icon: const Icon(Icons.thumb_down),
        ),
        trailing: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).agree(article.articleId, _person.uid);
          },
          icon: const Icon(Icons.thumb_up),
        ),
      );
    }
    return _basicCard(article, locked: true);
  }

  Widget _votedCard(Article article, bool isLiked) {
    return _basicCard(
      article,
      locked: false,
      trailing: Icon(isLiked ? Icons.child_care : Icons.broken_image),
      leading: IconButton(
        onPressed: () {
          if (isLiked) {
            ref.read(articlesControllerProvider.notifier).unAgree(article.articleId, _person.uid);
          } else {
            ref.read(articlesControllerProvider.notifier).unDisagree(article.articleId, _person.uid);
          }
        },
        icon: const Icon(Icons.undo),
      ),
      colour: isLiked ? kGoodColor.withAlpha(100) : kBadColor.withAlpha(100),
    );
  }

  Widget _authoredCard(Article article) {
    return _basicCard(
      isFlat: true,
      article,
      colour: kGoodColor.withAlpha(50),
      locked: false,
      leading: Column(children: [const Text("agreement"), Text(article.scoreStr)]),
    );
  }

  Widget _basicCard(Article article, {Widget? leading, Widget? trailing, Color? colour, required bool locked, bool? isFlat}) {
    return GestureDetector(
      child: Card(
        color: colour,
        elevation: isFlat != null ? 0 : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: article.url == null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
            children: [
              leading ?? const SizedBox(width: 10),
              Column(
                children: [
                  Text(article.title),
                  Text("- ${article.authorAlias} -", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                ],
              ),

              if (article.url != null) const Icon(Icons.link),
              trailing ?? const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      onTap: () => GoTo.articleDetailScreen(context, article, _person, _unlockVoting),
    );
  }
}
