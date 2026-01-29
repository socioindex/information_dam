import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  const ArticleScreen(this.article, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(constraints: BoxConstraints(maxHeight: 400),child: Column(children: [
        TextField(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          OutlinedButton(onPressed: Navigator.of(context).pop, child: const Text('cancel')),
          ElevatedButton(onPressed: (){
            
          }, child: const Text('comment')),
        ],)
      ])),
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

  Widget get _content => Text(widget.article.content!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.tag ?? "What do you think?")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _titleText,
            if (widget.article.url != null) _urlButton,
            if (widget.article.content != null) _content,
            OutlinedButton(onPressed: () {}, child: const Text("show comments")),
          ],
        ),
      ),
    );
  }
}
