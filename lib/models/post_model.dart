import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postId;
  final String description;
  final String datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  Post(
      {required this.uid,
      required this.postId,
      required this.username,
      required this.postUrl,
      required this.datePublished,
      required this.description,
      required this.profImage,
      required this.likes});
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'description': description,
        'postUrl': postUrl,
        'postId': postId,
        'likes': likes,
        "datePublished": datePublished,
        "profImage": profImage,
      };
  static Post fromMap(DocumentSnapshot snapshot) {
    return Post(
        uid: snapshot['uid'] ?? '',
        datePublished: snapshot['datePublished'] ?? '',
        username: snapshot['username'] ?? '',
        profImage: snapshot['profImage'] ?? [],
        description: snapshot['description'] ?? '',
        postId: snapshot['postId'] ?? '',
        postUrl: snapshot['postUrl'] ?? [],
        likes: snapshot['likes'] ?? '');
  }
}
