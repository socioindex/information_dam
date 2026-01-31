import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:information_dam/utility/show_messages.dart';

import '../../model/person.dart';
import 'auth_repository.dart';

//TODO figure out stateProvider update
final personProvider = StateProvider<Person?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository, super(false);

  useWithoutAccount(BuildContext context) async {
    state = true;
    final result = await _authRepository.useWithoutAccount();
    state = false;
    result.fold((l) => showSnackyBar(context, l.message), (alias) => showSnackyBar(context, "Your username is $alias"));
  }

  createAccount(BuildContext context, String email, String password, bool wantsCommunication, {String? preference}) async {
    state = true;
    final result = await _authRepository.signUp(email, password, wantsCommunication, preference: preference);
    state = false;
    result.fold((l) async {
      if (l.message == "The email address is already in use by another account.") {
        final newResult = await _authRepository.logIn(email, password);
        newResult.fold((l) => showSnackyBar(context, l.message), (r) => null);
      } else {
        showSnackyBar(context, l.message);
      }
    }, (alias) => showSnackyBar(context, "Your username is $alias"));
  }

  logIn(BuildContext context, String email, String password) async {
    state = true;
    final result = await _authRepository.logIn(email, password);
    state = false;
    result.fold((l) => showSnackyBar(context, l.message), (r) => null);
  }

  signOut(BuildContext context) {
    _authRepository.signOut();
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
