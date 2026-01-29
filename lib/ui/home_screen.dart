import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/articles/articles_controller.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/navigation.dart';
import 'package:information_dam/ui/custom_widgets.dart';
import 'package:information_dam/utility/error_loader.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Widget _articleTile(Article article) {
    return ListTile(title: Center(child: Text(article.title)), onTap: () => GoTo.articleDetailScreen(context, article),);
  }

  @override
  Widget build(BuildContext context) {
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
                  return _articleTile(article);
                },
              );
            },
            error: (error, stackTrace) => ErrorPage(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
