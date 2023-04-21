import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/resources/storage_functions.dart';
import 'package:uuid/uuid.dart';

class Firestorefunctions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String uid, String description, Uint8List file,
      String username, String profImage) async {
    String res = "Some err occoured";
    try {
      String postUrl =
          await StorageFunctions().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          uid: uid,
          postId: postId,
          username: username,
          postUrl: postUrl,
          datePublished: DateTime.now().toString(),
          description: description,
          profImage: profImage,
          likes: []);
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {}
  }

  Future<String> postComment(String uid, String postId, String photoUrl,
      String username, String text) async {
    String res = "Some Error Occcoured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          'commentId': commentId,
          'uid': uid,
          'photoUrl': photoUrl,
          'username': username,
          'comment': text,
          'datePublished': DateTime.now().toString(),
        });
        res = "success";
      } else {}
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> follow(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List following = snapshot['following'];
      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<String> deletePost(String postId) async {
    String res = 'Some error occoured';
    try {
      await _firebaseFirestore.collection("posts").doc(postId).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
