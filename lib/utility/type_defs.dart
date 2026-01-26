import 'package:fpdart/fpdart.dart';
import 'dart:async';

typedef FutureEitherFailureOr<T> = Future<Either<Failure, T>>;


class Failure {
  final String message;
  Failure(this.message);
}
