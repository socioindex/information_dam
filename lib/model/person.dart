import 'dart:convert';

import 'package:flutter/widgets.dart';

//TODO favouriteColor
class Person {
  final String uid;
  final String? email;
  final String alias; 
  Person({
    required this.uid,
    this.email,
    required this.alias,
  });



  Person copyWith({
    String? uid,
    ValueGetter<String?>? email,
    String? alias,
  }) {
    return Person(
      uid: uid ?? this.uid,
      email: email != null ? email() : this.email,
      alias: alias ?? this.alias,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'alias': alias,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      email: map['email'],
      alias: map['alias'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));

  @override
  String toString() => 'Person(uid: $uid, email: $email, alias: $alias)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Person &&
      other.uid == uid &&
      other.email == email &&
      other.alias == alias;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ alias.hashCode;
}
