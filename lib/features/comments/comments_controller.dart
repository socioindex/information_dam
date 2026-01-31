import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/authentication/auth_controller.dart';
import 'package:information_dam/features/comments/comments_repository.dart';
import 'package:information_dam/model/comment.dart';
import 'package:information_dam/utility/show_messages.dart';

final commentsControllerProvider = Provider.autoDispose.family<CommentsController, String>((ref, String articleId) {
  final commentsRepo = ref.watch(commentsRepositoryProvider(articleId));
  return CommentsController(commentRepository: commentsRepo, ref: ref);
});

class CommentsController {
  final CommentsRepository _commentRepository;
  final Ref _ref;
  CommentsController({required CommentsRepository commentRepository, required Ref ref}) : _commentRepository = commentRepository, _ref = ref;

  //   Stream<List<Comment>> getArticleComments(String articleId) {
  //   return _commentRepository.getArticleComments();
  // }

  Future<String> getUserComment() async {
    final person = _ref.read(personProvider)!;
    final comment = await _commentRepository.getUserComment(person.uid);
    return comment;
  }

  void addComment(BuildContext context, String commentText) async {
    final person = _ref.read(personProvider)!;

    final comment = Comment(commentText: commentText, commentId: person.uid, agreement: [], authorAlias: person.alias);
    final result = await _commentRepository.addComment(comment);

    result.fold((l) => showSnackyBar(context, l.message), (r) => null);
  }

  deleteComment(String commentId) {
    _commentRepository.deleteComment(commentId);
  }

  //TODO figure out why void doesnt work
  agree(String commentId, String userId) => _commentRepository.agree(commentId, userId);

  unAgree(String commentId, String userId) => _commentRepository.unAgree(commentId, userId);
  // disagree(String commentId, String userId) => _commentRepository.disagree(commentId, userId);
  // unDisgree(String commentId, String userId) => _commentRepository.unDisagree(commentId, userId);
}
