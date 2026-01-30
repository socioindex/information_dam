import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/comments/comments_controller.dart';
import 'package:information_dam/features/comments/comments_repository.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/model/person.dart';
import 'package:information_dam/utility/error_loader.dart';
import 'package:information_dam/utility/show_messages.dart';
import 'package:information_dam/utility/text_validation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/comment.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  final Person person;
  const ArticleScreen(this.article, this.person, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  final _commentController = TextEditingController();
  bool _showComments = false;
  bool _userHasInteracted = false;
  List<Comment> _listOfComments = [];
  bool _gotComments = false;
  String? _likedCommentId;
  @override
  void initState() {
    super.initState();
    _getUserComment();
  }

  void _getUserComment() async {
    await ref.read(commentsControllerProvider(widget.article.articleId)).getUserComment().then((comment) {
      if (comment != "") {
        _commentController.text = comment;
        setState(() {
          _userHasInteracted = true;
          _showComments = true;
        });
      }
    });
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        constraints: BoxConstraints(maxHeight: 400),
        child: Center(
          child: Column(
            children: [
              const Text("each user is limited to one comment per article"),
              TextField(controller: _commentController),
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
                          _userHasInteracted = true;
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
    );
  }

  Widget get _titleText {
    return Text(widget.article.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  TextStyle get _urlStyle => TextStyle(fontSize: 20);

  Widget get _urlButton => TextButton(
    onPressed: () async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("You are about to go to ${widget.article.url!}"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('NO WAY'),
              ),
            ],
          );
        },
      ).then((value) async {
        if (value == true) {
          final Uri url = Uri.parse(widget.article.url!);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        }
      });
    },
    child: Text(widget.article.url!, style: _urlStyle),
  );

  //TODO style content
  Widget get _contentWidget => Text(widget.article.content!);

  void _showCommentList() {
    if (!_gotComments) {
      setState(() async {
        _listOfComments = await ref.read(commentsRepositoryProvider(widget.article.articleId)).getArticleComments().first;
      });

      _gotComments = true;
    }
    setState(() {
      _showComments = !_showComments;
    });
  }

  Widget _commentWidget(Comment comment) {
    final title = comment.commentText;
    if (!_userHasInteracted) {
      return _notInteractedYetTile(title, comment.commentId);
    } else if (comment.commentId == widget.person.uid) {
      return _authoredTile(title, comment.commentId);
    } else if (comment.agreement.contains(widget.person.uid)) {
      return _likedComment(title);
    } else {
      return _remainingTile(title);
    }
  }

  Widget _notInteractedYetTile(String title, String commentId) {
    return ListTile(
      title: Text(title),
      trailing: TextButton(
        onPressed: () {
          ref.read(commentsControllerProvider(widget.article.articleId)).agree(commentId, widget.person.uid);
          setState(() {
            _userHasInteracted = true;
          });
        },
        child: const Text('I agree!'),
      ),
    );
  }

  Widget _authoredTile(String title, String commentId) {
    return ListTile(
      title: Text(title),
      tileColor: Colors.blue.withAlpha(50),
      trailing: TextButton(
        onPressed: () {
          ref.read(commentsControllerProvider(widget.article.articleId)).deleteComment(commentId);
          setState(() {
            _userHasInteracted = false;
          });
        },
        child: const Text('delete'),
      ),
    );
  }

  Widget _likedComment(String title) {
    return ListTile(title: Text(title), tileColor: Colors.green.withAlpha(50));
  }

  Widget _remainingTile(String title) {
    return ListTile(title: Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.tag ?? "What do you think?")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _titleText,
              if (widget.article.url != null) _urlButton,
              if (widget.article.content != null) _contentWidget,
              OutlinedButton(
                onPressed: () {
                  _showCommentList();
                },
                child: Text(_showComments ? "hide comments" : "show comments"),
              ),
              if (_showComments)
                ListView.builder(
                  itemCount: _listOfComments.length,
                  itemBuilder: (context, index) {
                    final comment = _listOfComments[index];
                    return _commentWidget(comment);
                  },
                ),
              // ref
              //     .watch(articleCommentsProvider(widget.article.articleId))
              //     .when(
              //       data: (comments) {
              //         return Expanded(
              //           child: ListView.builder(
              //             itemCount: comments.length,
              //             itemBuilder: (context, index) {
              //               final comment = comments[index];

              //               return _commentWidget(comment);
              //             },
              //           ),
              //         );
              //       },
              //       error: (error, stackTrace) => ErrorText(error.toString()),
              //       loading: () => const Loader(),
              //     ),
              if (!_userHasInteracted) ElevatedButton(onPressed: _showCommentDialog, child: const Text('Comment')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
