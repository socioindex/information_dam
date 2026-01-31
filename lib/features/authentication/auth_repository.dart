import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:information_dam/features/authentication/name_generator.dart';
import '../../model/person.dart';
import '../../utility/firebase_tools/firebase_providers.dart';
import '../../utility/type_defs.dart';

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChange;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = ref.read(authProvider);
  return AuthRepository(firestore: firestore, auth: auth);
});

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth}) : _auth = auth, _firestore = firestore;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _people => _firestore.collection('people');

  Stream<Person> getPersonData(String uid) {
    return _people.doc(uid).snapshots().map((event) => Person.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEitherFailureOr<String> useWithoutAccount() async {
    try {
      final anonCredential = await _auth.signInAnonymously();
      final newName = NameGenerator.name; 
      final newPerson = Person(uid: anonCredential.user!.uid, alias: newName);
      await _people.doc(newPerson.uid).set(newPerson.toMap());
      return right(newName);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  signOut() {
    _auth.signOut();
  }

  FutureEitherFailureOr<String> signUp(String email, String password, bool wantsCommunication, {String? preference}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final newName = NameGenerator.name;
      final person = Person(uid: userCredential.user!.uid, email: email, alias: newName);

      await _people.doc(person.uid).set(person.toMap());
      if (wantsCommunication) {
        await _people.doc(person.uid).update({"EMAIL ME": preference});
      }
      return right(newName);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEitherFailureOr<void> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
