import 'package:flutter/widgets.dart';
//TODO favouriteColor
class Person {
  final String uid;
  final String? email;
  Person({required this.uid, this.email});

  Person copyWith({String? uid, ValueGetter<String?>? email}) {
    return Person(uid: uid ?? this.uid, email: email != null ? email() : this.email);
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email};
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(uid: map['uid'] ?? '', email: map['email']);
  }
}
