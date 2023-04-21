import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_functions.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: const Text("Comments"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  snap: snapshot.data!.docs[index].data(),
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kTextTabBarHeight,
          padding: const EdgeInsets.only(left: 16, right: 8),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 16),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Comment as ${user.username}"),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String res = await Firestorefunctions().postComment(
                      user.uid,
                      widget.snap['postId'],
                      user.profilePic,
                      user.username,
                      _commentController.text);
                  if (res == 'success') {
                    setState(() {
                      _commentController.clear();
                    });
                  } else {
                    showSnackBar(context, res, Colors.red);
                  }
                },
                icon: const Icon(Icons.send_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }
}
