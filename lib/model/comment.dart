import 'dart:convert';

import 'package:flutter/foundation.dart';

class Comment {
  final String commentText;
  //'commentId' matches a person's uid, as to ensure only one comment per user.
  final String commentId;
  final List<String> agreement;
  final String authorAlias;

  int get score {
    return (agreement.length);
  }

  String get scoreStr {
    return score.toString();
  }

  Comment({required this.commentText, required this.commentId, required this.agreement, required this.authorAlias});

  Comment copyWith({String? commentText, String? commentId, List<String>? agreement, String? authorAlias}) {
    return Comment(
      commentText: commentText ?? this.commentText,
      commentId: commentId ?? this.commentId,
      agreement: agreement ?? this.agreement,
      authorAlias: authorAlias ?? this.authorAlias,
    );
  }

  Map<String, dynamic> toMap() {
    return {'commentText': commentText, 'commentId': commentId, 'agreement': agreement, 'authorAlias': authorAlias};
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentText: map['commentText'] ?? '',
      commentId: map['commentId'] ?? '',
      agreement: List<String>.from(map['agreement']),
      authorAlias: map['authorAlias'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(commentText: $commentText, commentId: $commentId, agreement: $agreement, authorAlias: $authorAlias)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.commentText == commentText &&
        other.commentId == commentId &&
        listEquals(other.agreement, agreement) &&
        other.authorAlias == authorAlias;
  }

  @override
  int get hashCode {
    return commentText.hashCode ^ commentId.hashCode ^ agreement.hashCode ^ authorAlias.hashCode;
  }
}
