import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:information_dam/features/comments/comments_controller.dart';
import 'package:information_dam/features/comments/comments_repository.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/model/person.dart';
import 'package:information_dam/utility/show_messages.dart';
import 'package:information_dam/utility/text_validation.dart';

import '../model/comment.dart';
import 'custom_widgets.dart';

String getMakeshiftTitle(String status) {
  if (status == "explain") {
    return "select a comment to agree!";
  } else {
    return "this screen needs work! sorry!";
  }
}

Color goodColorShade = Colors.green.withAlpha(100);

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  final Person person;
  const ArticleScreen(this.article, this.person, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  final _commentController = TextEditingController();
  List<Comment>? _listOfComments;
  String? _likedCommentId;
  String? _originalLikedCommentId;
  bool _hasAuthoredComment = false;
  bool _isShowingComments = false;
  bool _hasCommentedThisTime = false;

  @override
  void initState() {
    super.initState();
    _getUserComment();
  }

  void _getUserComment() async {
    await ref.read(commentsControllerProvider(widget.article.articleId)).getUserComment().then((comment) {
      if (comment != "") {
        _commentController.text = comment;
      }
    });
  }

  void _populateOnFirstShow() async {
    await ref.read(commentsRepositoryProvider(widget.article.articleId)).getArticleComments().first.then((commentList) {
      setState(() {
        _listOfComments = commentList;

        for (final comment in commentList) {
          if (comment.commentId == widget.person.uid) {
            _hasAuthoredComment = true;
            break;
          }
          if (comment.agreement.contains(widget.person.uid)) {
            _likedCommentId = comment.commentId;
            _originalLikedCommentId = comment.commentId;
            break;
          }
        }
      });
    });
  }

  void _populateList() async {
    await ref.read(commentsRepositoryProvider(widget.article.articleId)).getArticleComments().first.then((value) {
      _listOfComments = value;
    });
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        constraints: BoxConstraints(maxHeight: 240),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("limit one comment or interaction per article"),
                TextField(controller: _commentController, maxLength: 140),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(onPressed: Navigator.of(context).pop, child: const Text('cancel')),
                    ElevatedButton(
                      onPressed: () {
                        if (isValidTextValue(_commentController)) {
                          ref
                              .read(commentsControllerProvider(widget.article.articleId))
                              .addComment(context, validTextValueReturner(_commentController));
                          setState(() {
                            _populateList();
                            _hasAuthoredComment = true;
                            _hasCommentedThisTime = true;
                          });

                          Navigator.pop(context);
                        } else {
                          showSnackyBar(context, 'invalid input');
                        }
                      },
                      child: const Text('comment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_likedCommentId != _originalLikedCommentId) {
          final commentController = ref.read(commentsControllerProvider(widget.article.articleId));
          if (_originalLikedCommentId != null) {
            commentController.unAgree(_originalLikedCommentId!, widget.person.uid);
          }
          if (_likedCommentId != null) {
            commentController.agree(_likedCommentId!, widget.person.uid);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(getMakeshiftTitle(_isShowingComments ? "explain" : ""))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Flexible(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArticleDetail.titleText(widget.article.title),

                      Column(
                        children: [
                          if (widget.article.url != null) ArticleDetail.urlButton(widget.article.url!, context),
                          if (widget.article.content != null) ArticleDetail.contentText(widget.article.content!),
                          ElevatedButton(
                            onPressed: () {
                              if (_listOfComments == null) {
                                _populateOnFirstShow();
                              }
                              setState(() {
                                _isShowingComments = !_isShowingComments;
                              });
                            },
                            child: Text(_isShowingComments ? "hide comments" : "show comments"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isShowingComments)
                  Flexible(
                    flex: 5,
                    child: Column(
                      children: [
                        (_listOfComments == null || _listOfComments!.isEmpty)
                            ? const Text('no comments yet')
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: _listOfComments!.length,
                                  itemBuilder: (context, index) {
                                    final comment = _listOfComments![index];
                                    return _commentTile(comment, index);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                if (_isShowingComments)
                  Flexible(
                    flex: 1,
                    child: _hasCommentedThisTime
                        ? Container()
                        : _likedCommentId != null
                        ? const Text('cannot comment')
                        : ElevatedButton(onPressed: _showCommentDialog, child: Text(_hasAuthoredComment ? "change comment" : "add comment")),
                  ),
                if (!_isShowingComments) Flexible(flex: 5, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _commentTile(Comment comment, int index) {
    if (_hasAuthoredComment) {
      if (comment.commentId == widget.person.uid) {
        return _authoredTile(comment, index);
      } else {
        return ListTile(title: Center(child: Text(comment.commentText)));
      }
    }
    if (_likedCommentId == comment.commentId) {
      return ListTile(
        tileColor: goodColorShade,
        title: Center(child: Text(comment.commentText)),
        onTap: () {
          setState(() {
            _likedCommentId = null;
          });
        },
      );
    } else {
      return ListTile(
        title: Center(child: Text(comment.commentText)),
        onTap: () {
          setState(() {
            _likedCommentId = comment.commentId;
          });
        },
      );
    }
  }

  Widget _authoredTile(Comment comment, int index) {
    return ListTile(
      leading: Text(comment.scoreStr),
      tileColor: Colors.blue.withAlpha(50),
      title: Center(child: Text(comment.commentText)),
      trailing: TextButton(
        onPressed: () {
          ref.read(commentsControllerProvider(widget.article.articleId)).deleteComment(widget.person.uid);
          setState(() {
            _listOfComments!.removeAt(index);
            _likedCommentId = null;
            _hasAuthoredComment = false;
            _hasCommentedThisTime = true;
          });
        },
        child: const Text('delete'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
