import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/articles/articles_controller.dart';
import 'package:information_dam/ui/custom_widgets.dart';
import 'package:information_dam/utility/show_messages.dart';
import 'package:information_dam/utility/text_validation.dart';

const String kDontPostUnless =
    "We are not looking for original thoughts. Pick something anyone would agree with, even if it's obvious! Maybe something simple is more important than we realize. If it turns out meh you can ask your peers for downvotes so it gets deleted quickly.";

const String kTypesOfPosts =
    "You can share a short statement or you can use that field as a title to share a link or additional content. Copy and pasting is recommended, our in-house-text-editor is still under construction.";

class CreateArticleScreen extends ConsumerStatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends ConsumerState<CreateArticleScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _urlController = TextEditingController();
  bool _titleOnly = false;
  bool _hasContent = false;
  bool _hasLink = false;
  int _pageIndex = 1;
  // '_returnIndex' allows for the content input to be skipped from titleOnly to page 3
  int _returnIndex = 1;

  void _titleAquisition() {
    if (!isValidTextValue(_titleController)) {
      showSnackyBar(context, "a title is required");
      return;
    } else if (_titleOnly == false && _hasContent == false && _hasLink == false) {
      showSnackyBar(context, 'please specify the type of post.');
      return;
    } else if (_titleOnly) {
      _goToPage3(1);
      return;
    } else {
      setState(() {
        _pageIndex = 2;
      });
    }
  }

  void _from2To3() {
    if (_hasLink && !isValidLink(_urlController)) {
      showSnackyBar(context, "Please enter a valid url");
    } else {
      _goToPage3(2);
    }
  }

  void _goToPage3(int returnIndex) {
    setState(() {
      _pageIndex = 3;
      _returnIndex = returnIndex;
    });
  }

  void _submitPaperWork() {
    ref
        .read(articlesControllerProvider.notifier)
        .postArticle(
          title: validTextValueReturner(_titleController),
          context: context,
          content: (_hasContent && isValidTextValue(_contentController)) ? validTextValueReturner(_contentController) : null,
          url: _hasLink ? validTextValueReturner(_urlController) : null,
        );
  }
  //The post creation takes place over 3 pages
  // The first has kDontPostUnless and kTypesOfPost and asks for a title.
  // the second is for content and a link
  // the third used to be for tags

  @override
  Widget build(BuildContext context) {
    if (_pageIndex == 1) {
      return _page1;
    } else if (_pageIndex == 2) {
      return _page2;
    } else {
      return _page3;
    }
  }

  Widget get _page1 => Scaffold(
    appBar: AppBar(title: const Text("Create Post Page")),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: const Text(kDontPostUnless)),
          Padding(padding: const EdgeInsets.all(8.0), child: const Text(kTypesOfPosts)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (_) {
                if (!_titleOnly && !_hasContent && !_hasLink) {
                  setState(() {
                    _titleOnly = true;
                  });
                }
              },
              controller: _titleController,
              maxLength: 70,
              decoration:  InputDecoration(hintText: _titleOnly ? "statement" :"title"),
            ),
          ),
          CheckboxListTile(
            value: _titleOnly,
            onChanged: (value) {
              setState(() {
                _titleOnly = value!;
                if (value == true) {
                  _hasContent = false;
                  _hasLink = false;
                }
              });
            },
            title: const Text('title only'),
          ),
          CheckboxListTile(
            value: _hasLink,
            onChanged: (value) {
              setState(() {
                _hasLink = value!;
                if (value == true) {
                  _titleOnly = false;
                }
              });
            },
            title: const Text('include a link'),
          ),
          CheckboxListTile(
            value: _hasContent,
            onChanged: (value) {
              setState(() {
                _hasContent = value!;
                if (value == true) {
                  _titleOnly = false;
                }
              });
            },
            title: const Text('include additional text'),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                OutlinedButton(onPressed: _titleAquisition, child: const Text('Proceed')),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget get _page2 => Scaffold(
    floatingActionButton: FloatingActionButton(onPressed: _from2To3, child: const Icon(Icons.arrow_forward)),
    appBar: AppBar(
      title: Text(_titleController.text),
      leading: IconButton(
        onPressed: () {
          setState(() {
            _pageIndex = 1;
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_hasLink)
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "url"),
            ),
          if (_hasContent)
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "type or paste content here"),
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
            ),
        ],
      ),
    ),
  );
//TODO make this page match articleDetail
  Widget get _page3 => Scaffold(
    appBar: AppBar(
      title: const Text('Your Post:'),
      leading: IconButton(
        onPressed: () {
          setState(() {
            _pageIndex = _returnIndex;
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            ArticleDetail.titleText(validTextValueReturner(_titleController)),
            if(_hasLink)
            ArticleDetail.urlButton(validTextValueReturner(_urlController), context),
            if(_hasContent)
            ArticleDetail.contentText(validTextValueReturner(_contentController)),
            ElevatedButton(onPressed: _submitPaperWork, child: const Text("Post!")),
            const SizedBox(height: 10,)
        ]),
      ),
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
  }
}
