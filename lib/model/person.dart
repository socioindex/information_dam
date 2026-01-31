import 'dart:convert';

import 'package:flutter/widgets.dart';

//TODO favouriteColor
class Person {
  final String uid;
  final String? email;
  final String? alias; 
  Person({
    required this.uid,
    this.email,
    this.alias,
  });

  Person copyWith({
    String? uid,
    ValueGetter<String?>? email,
    ValueGetter<String?>? alias,
  }) {
    return Person(
      uid: uid ?? this.uid,
      email: email != null ? email() : this.email,
      alias: alias != null ? alias() : this.alias,
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
      alias: map['alias'],
    );
  }



  @override
  String toString() => 'Person(uid: $uid, email: $email, alias: $alias)';


}
