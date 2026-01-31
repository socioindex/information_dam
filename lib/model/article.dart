import 'dart:convert';
import 'package:flutter/foundation.dart';

class Article {
  final String articleId;
  final String authorId;
  final String title;
  final String? content;
  final String? url;
  final List<String> agreement;
  final List<String> disagreement;
  final String authorAlias; 
  Article({
    required this.articleId,
    required this.authorId,
    required this.title,
    this.content,
    this.url,
    required this.agreement,
    required this.disagreement,
    required this.authorAlias,
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
    String? authorAlias,
  }) {
    return Article(
      articleId: articleId ?? this.articleId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content != null ? content() : this.content,
      url: url != null ? url() : this.url,
      agreement: agreement ?? this.agreement,
      disagreement: disagreement ?? this.disagreement,
      authorAlias: authorAlias ?? this.authorAlias,
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
      'authorAlias': authorAlias,
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
      authorAlias: map['authorAlias'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Article(articleId: $articleId, authorId: $authorId, title: $title, content: $content, url: $url, agreement: $agreement, disagreement: $disagreement, authorAlias: $authorAlias)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Article &&
      other.articleId == articleId &&
      other.authorId == authorId &&
      other.title == title &&
      other.content == content &&
      other.url == url &&
      listEquals(other.agreement, agreement) &&
      listEquals(other.disagreement, disagreement) &&
      other.authorAlias == authorAlias;
  }

  @override
  int get hashCode {
    return articleId.hashCode ^
      authorId.hashCode ^
      title.hashCode ^
      content.hashCode ^
      url.hashCode ^
      agreement.hashCode ^
      disagreement.hashCode ^
      authorAlias.hashCode;
  }
}
