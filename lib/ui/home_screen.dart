import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/articles/articles_controller.dart';
import 'package:information_dam/features/authentication/auth_controller.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/model/person.dart';
import 'package:information_dam/navigation.dart';
import 'package:information_dam/ui/custom_widgets.dart';
import 'package:information_dam/utility/error_loader.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<String> _articlesViewed = [];

  unlockVoting(String articleId) {
    _articlesViewed.add(articleId);
  }

  Widget _articleTile(Article article, Person person) {
    if (article.authorId == person.uid) {
      return ListTile(
        onTap: () => GoTo.articleDetailScreen(context, article, person, null),
        leading: Text(article.scoreStr),
        tileColor: Colors.blue.withAlpha(50),
        title: Text(article.title),
      );
    }
    if (article.agreement.contains(person.uid)) {
      return ListTile(
        leading: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).unAgree(article.articleId, person.uid);
          },
          icon: const Icon(Icons.undo),
        ),
        onTap: () => GoTo.articleDetailScreen(context, article, person, null),
        tileColor: Colors.green.withAlpha(50),
        title: Center(child: Text(article.title)),
      );
    }
    if (article.disagreement.contains(person.uid)) {
      return ListTile(
        leading: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).unDisagree(article.articleId, person.uid);
          },
          icon: const Icon(Icons.undo),
        ),
        onTap: () => GoTo.articleDetailScreen(context, article, person, null),
        tileColor: Colors.red.withAlpha(50),
        title: Center(child: Text(article.title)),
      );
    }
    if (_articlesViewed.contains(article.articleId)) {
      return ListTile(
        onTap: () => GoTo.articleDetailScreen(context, article, person, null),
        leading: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).disagree(article.articleId, person.uid);
          },
          icon: const Icon(Icons.arrow_downward),
        ),
        title: Center(child: Text(article.title)),
        trailing: IconButton(
          onPressed: () {
            ref.read(articlesControllerProvider.notifier).agree(article.articleId, person.uid);
          },
          icon: const Icon(Icons.arrow_upward),
        ),
      );
    }

    return ListTile(
      title: Center(child: Text(article.title)),
      onTap: () => GoTo.articleDetailScreen(context, article, person, unlockVoting(article.articleId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(personProvider)!;
    return Scaffold(
      appBar: customAppBar(
        "this is home screen",
        hasInfoButton: true,
        context: context,
        actions: [TextButton(onPressed: () => GoTo.createPostScreen(context), child: const Text("create"))],
      ),
      body: ref
          .watch(articleFeedProvider)
          .when(
            data: (listOfArticles) {
              return ListView.builder(
                itemCount: listOfArticles.length,
                itemBuilder: (context, index) {
                  final article = listOfArticles[index];
                  return _articleTile(article, user);
                },
              );
            },
            error: (error, stackTrace) => ErrorPage(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
