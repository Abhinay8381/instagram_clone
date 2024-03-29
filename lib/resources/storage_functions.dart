import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageFunctions {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference reference = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);
    if (isPost == true) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }
    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
