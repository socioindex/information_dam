import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../model/article.dart';
import '../../utility/firebase_tools/firebase_providers.dart';
import '../../utility/type_defs.dart';

final articlesRepositoryProvider = Provider<ArticlesRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ArticlesRepository(firestore: firestore);
});

class ArticlesRepository {
  final FirebaseFirestore _firestore;

  ArticlesRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _articles => _firestore.collection('articles');

  FutureEitherFailureOr<void> postArticle(Article article) async {
    try {
      _articles.doc(article.articleId).set(article.toMap());
      return right(null);
      // return right(_articles.doc(article.articleId).update({'timeOfCreation': FieldValue.serverTimestamp()}));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Article>> get articleFeed =>
      _articles.snapshots().map((event) => event.docs.map((e) => Article.fromMap(e.data() as Map<String, dynamic>)).toList());

  void agree(String articleId, String userId) async {
    await _articles.doc(articleId).update({
      'agreement': FieldValue.arrayUnion([userId]),
    });
  }

  void unAgree(String articleId, String userId) async {
    await _articles.doc(articleId).update({
      'agreement': FieldValue.arrayRemove([userId]),
    });
  }

  void disagree(String articleId, String userId) async {
    await _articles.doc(articleId).update({
      'disagreement': FieldValue.arrayUnion([userId]),
    });
  }

  void unDisagree(String articleId, String userId) async {
    await _articles.doc(articleId).update({
      'disagreement': FieldValue.arrayRemove([userId]),
    });
  }

  void delete(String articleId) async {
    await _articles.doc(articleId).update({'comments': FieldValue.delete()});
    await _articles.doc(articleId).delete();
  }
}
