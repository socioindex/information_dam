import 'package:flutter/material.dart';

class Article {
  final String articleId;
  final String authorId;
  final String title;
  final String? content;
  final String? url;
  final List<String> agreement;
  final List<String> disagreement;
  Article({
    required this.articleId,
    required this.authorId,
    required this.title,
    this.content,
    this.url,
    required this.agreement,
    required this.disagreement,
  });

  int get score {
    return (agreement.length - disagreement.length);
  }

  String get scoreStr {
    return score.toString();
  }

  Article copyWith({
    String? articleId,
    String? authorId,
    String? title,
    ValueGetter<String?>? content,
    ValueGetter<String?>? url,
    List<String>? agreement,
    List<String>? disagreement,
  }) {
    return Article(
      articleId: articleId ?? this.articleId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content != null ? content() : this.content,
      url: url != null ? url() : this.url,
      agreement: agreement ?? this.agreement,
      disagreement: disagreement ?? this.disagreement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'authorId': authorId,
      'title': title,
      'content': content,
      'url': url,
      'agreement': agreement,
      'disagreement': disagreement,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      articleId: map['articleId'] ?? '',
      authorId: map['authorId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'],
      url: map['url'],
      agreement: List<String>.from(map['agreement']),
      disagreement: List<String>.from(map['disagreement']),
    );
  }
}
