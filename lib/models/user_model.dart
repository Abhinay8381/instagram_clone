import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String profilePic;
  final String bio;
  final List followers;
  final List following;
  User(
      {required this.uid,
      required this.email,
      required this.username,
      required this.profilePic,
      required this.bio,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'bio': bio,
        'profilePic': profilePic,
        'email': email,
        'followers': followers,
        "following": following,
      };
  static User fromMap(DocumentSnapshot snapshot) {
    return User(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      profilePic: snapshot['profilePic'] ?? '',
      bio: snapshot['bio'] ?? '',
      followers: snapshot['followers'] ?? [],
      following: snapshot['following'] ?? [],
    );
  }
}
