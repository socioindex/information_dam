import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:information_dam/model/comment.dart';
import 'package:information_dam/utility/type_defs.dart';


import '../../utility/firebase_tools/firebase_providers.dart';

final commentsRepositoryProvider = Provider.autoDispose.family<CommentsRepository, String>((ref, String articleId) {
  final firestore = ref.watch(firestoreProvider);
  return CommentsRepository(firestore: firestore, articleId: articleId);
});

final articleCommentsProvider = StreamProvider.autoDispose.family<List<Comment>, String>((ref, String articleId) {
  final repoController = ref.watch(commentsRepositoryProvider(articleId));
  return repoController.getArticleComments();
});

//TODO make fields private
class CommentsRepository {
  final FirebaseFirestore firestore;
  final String articleId;

  CommentsRepository({required this.firestore, required this.articleId});

  CollectionReference get _articleComments => firestore.collection('articles').doc(articleId).collection('comments');




  Stream<List<Comment>> getArticleComments() {
    return _articleComments.snapshots().map((event) => event.docs.map((e) => Comment.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

      Future<String> getUserComment(String userId) async {
    final document = await _articleComments.doc(userId).snapshots().first;
    if (_isDocumentExist(document)) {
      final data = document.data() as Map<String, dynamic>;
      return data['commentText'];
    } else {
      return '';
    }
  }

  bool _isDocumentExist(DocumentSnapshot document) {
    if (document.exists) {
      return true;
    } else {
      return false;
    }
  }

  FutureEitherFailureOr<void> addComment(Comment comment) async {
    try {
      return right(_articleComments.doc(comment.commentId).set(comment.toMap()));
    } on FirebaseException {
      return left(Failure('something went wrong(firebase exception)'));
    } catch (e) {
      return left(Failure('something went wrong'));
    }
  }

  deleteComment(String commentId) {
    _articleComments.doc(commentId).delete();
  }

  void agree(String commentId, String userId) async {
    await _articleComments.doc(commentId).update({
      'agreement': FieldValue.arrayUnion([userId]),
    });
  }

  void unAgree(String commentId, String userId) async {
    await _articleComments.doc(commentId).update({
      'agreement': FieldValue.arrayRemove([userId]),
    });
  }

  // void disagree(String commentId, String userId) async {
  //   await _articleComments.doc(commentId).update({
  //     'disagreement': FieldValue.arrayUnion([userId]),
  //   });
  // }

  // void unDisagree(String commentId, String userId) async {
  //   await _articleComments.doc(commentId).update({
  //     'disagreement': FieldValue.arrayRemove([userId]),
  //   });
  // }
}
