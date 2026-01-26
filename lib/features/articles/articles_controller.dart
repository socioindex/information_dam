import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';


import '../../model/article.dart';
import '../../utility/show_messages.dart';
import '../authentication/auth_controller.dart';
import 'articles_repository.dart';

final articleFeedProvider = StreamProvider<List<Article>>((ref) {
  final articlesController = ref.read(articlesControllerProvider.notifier);
  return articlesController.articleFeed;
});

final articlesControllerProvider = StateNotifierProvider<ArticlesController, bool>((ref) {
  final articlesRepo = ref.read(articlesRepositoryProvider);
  return ArticlesController(articlesRepository: articlesRepo, ref: ref);
});

class ArticlesController extends StateNotifier<bool> {
  final ArticlesRepository _articlesRepository;
  final Ref _ref;

  ArticlesController({required ArticlesRepository articlesRepository, required Ref ref})
    : _articlesRepository = articlesRepository,
      _ref = ref,
      super(false);

  Future<void> postArticle({required String title, String? url, String? content, required BuildContext context}) async {
    state = true;
    final newId = const Uuid().v1();
    final person = _ref.read(personProvider)!;
    final newArticle = Article(
      authorId: person.uid,
      articleId: newId,
      title: title,
      url: url,
      content: content,
      agreement: [person.uid],
      disagreement: [],
    );
    final result = await _articlesRepository.postArticle(newArticle);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted!');
      Navigator.of(context).pop(newId);
    });
  }

  Stream<List<Article>> get articleFeed => _articlesRepository.articleFeed;

  void agree(String articleId, String userId) => _articlesRepository.agree(articleId, userId);
  void disagree(String articleId, String userId) => _articlesRepository.disagree(articleId, userId);
  void unAgree(String articleId, String userId) => _articlesRepository.unAgree(articleId, userId);
  void unDisagree(String articleId, String userId) => _articlesRepository.unDisagree(articleId, userId);

  // void delete(String articleId) => _articlesRepository.delete(articleId);
}
