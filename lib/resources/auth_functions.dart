import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/resources/storage_functions.dart';

class AuthFunctions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromMap(snapshot);
  }

  Future<String> resgisterUser(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String result = "Some error occoured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty &&
          file.isNotEmpty) {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        String profilePic = await StorageFunctions()
            .uploadImageToStorage("ProfilePics", file, false);
        model.User user = model.User(
            uid: userCredential.user!.uid,
            email: email,
            username: username,
            profilePic: profilePic,
            bio: bio,
            followers: [],
            following: []);
        await _firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        result = "Success";
      } else {
        result = "Please fill all the fields and select a profile Photo";
      }
    } on FirebaseAuthException catch (error) {
      result = error.message.toString();
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = "Some error occoured";
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "Success";
      } on FirebaseAuthException catch (error) {
        result = error.message.toString();
      } catch (error) {
        result = error.toString();
      }
    } else if (email.isEmpty || password.isEmpty) {
      result = "Either email or password is Empty";
    }

    return result;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
