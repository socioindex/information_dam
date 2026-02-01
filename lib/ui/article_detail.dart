import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/comments/comments_controller.dart';
import 'package:information_dam/model/article.dart';
import 'package:information_dam/model/person.dart';
import 'package:information_dam/ui/custom_widgets.dart';

class ArticleDetail extends ConsumerStatefulWidget {
  final Article article;
  final Person person;
  const ArticleDetail(this.article, this.person, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends ConsumerState<ArticleDetail> {
  final _commentController = TextEditingController();
  String? _originalLikedCommentId;
  String? _likedCommentId;
  bool _showingComments = false;

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
        appBar: AppBar(
          actions: _showingComments
              ? [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showingComments = !_showingComments;
                      });
                    },
                    icon: const Icon(Icons.document_scanner),
                  ),
                ]
              : null,
          title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text("This is the author"),
                  children: [ElevatedButton(onPressed: Navigator.of(context).pop, child: const Text('ok'))],
                ),
              );
            },
            child: Text(widget.article.authorAlias),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Flexible(
                  flex: _showingComments ? 5 : 8,
                  child: Column(
                    children: [
                      ArticleStyles.titleText(widget.article.title),
                      const Divider(indent: 60, endIndent: 60),
                      if (widget.article.url != null) ArticleStyles.urlButton(widget.article.url!, context),
                      const Divider(indent: 60, endIndent: 60),
                      if (widget.article.content != null)
                        Expanded(child: SingleChildScrollView(child: ArticleStyles.contentText(widget.article.content!))),
                    ],
                  ),
                ),
                _showingComments
                    ? Flexible(flex: 8, child: Placeholder())
                    : Flexible(
                        flex: 5,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showingComments = !_showingComments;
                              });
                            },
                            child: const Text("show comments"),
                          ),
                        ),
                      ),
              ],
            ),
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
