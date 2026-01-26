class Comment {
  final String commentText;
  //'commentId' matches a person's uid, as to ensure only one comment per user.
  final String commentId;
  final List<String> agreement;
  final List<String> disagreement;
  Comment({required this.commentText, required this.commentId, required this.agreement, required this.disagreement});

  int get score {
    return (agreement.length - disagreement.length);
  }

  String get scoreStr {
    return score.toString();
  }

  Comment copyWith({String? commentText, String? commentId, List<String>? agreement, List<String>? disagreement}) {
    return Comment(
      commentText: commentText ?? this.commentText,
      commentId: commentId ?? this.commentId,
      agreement: agreement ?? this.agreement,
      disagreement: disagreement ?? this.disagreement,
    );
  }

  Map<String, dynamic> toMap() {
    return {'commentText': commentText, 'commentId': commentId, 'agreement': agreement, 'disagreement': disagreement};
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentText: map['commentText'] ?? '',
      commentId: map['commentId'] ?? '',
      agreement: List<String>.from(map['agreement']),
      disagreement: List<String>.from(map['disagreement']),
    );
  }
}
