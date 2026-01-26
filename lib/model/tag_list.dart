

class TagList {
  final List<String> tags; 
  TagList({
    required this.tags,
  });

  TagList copyWith({
    List<String>? tags,
  }) {
    return TagList(
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tags': tags,
    };
  }

  factory TagList.fromMap(Map<String, dynamic> map) {
    return TagList(
      tags: List<String>.from(map['tags']),
    );
  }

}
