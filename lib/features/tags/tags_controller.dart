import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/model/tag_list.dart';
import 'package:information_dam/utility/firebase_tools/firebase_providers.dart';

final tagsFeedProvider = StreamProvider.autoDispose<List<TagList>>((ref) {
  final tagsController = ref.read(tagsControllerProvider);
  return tagsController.tagFeed;
});

final tagsControllerProvider = Provider<TagsController>((ref) {
  final firestore = ref.read(firestoreProvider);
  return TagsController(firestore);
});

//TODO simplify for string list
class TagsController {
  final FirebaseFirestore firestore;

  TagsController(this.firestore);

  CollectionReference get _tags => firestore.collection('tags');

  //DATABASE PATH MUST BE SET BEFORE THIS FUNCTION WILL WORK
  addTag(String tag) {
    _tags.doc('tags').update({
      'tags': FieldValue.arrayUnion([tag]),
    });
  }

  Stream<List<TagList>> get tagFeed =>
      _tags.snapshots().map((event) => event.docs.map((e) => TagList.fromMap(e.data() as Map<String, dynamic>)).toList());
}
