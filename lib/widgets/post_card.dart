import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_functions.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Postcard extends StatefulWidget {
  final snap;

  const Postcard({super.key, required this.snap});

  @override
  State<Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<Postcard> {
  bool isLikeAnimating = false;
  int comments = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    if (mounted) {
      setState(() {
        comments = querySnapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid
                        ? showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    children: ['Delete']
                                        .map((e) => InkWell(
                                              onTap: () async {
                                                await Firestorefunctions()
                                                    .deletePost(
                                                        widget.snap['postId'])
                                                    .then((value) {
                                                  if (value == "success") {
                                                    showSnackBar(
                                                        context,
                                                        "Post deleted successfully",
                                                        Colors.green);
                                                  } else {
                                                    showSnackBar(context, value,
                                                        Colors.green);
                                                  }
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ))
                        : showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    children: ['Report']
                                        .map((e) => InkWell(
                                              onTap: () {
                                                showSnackBar(
                                                    context,
                                                    "Reported Successfully",
                                                    Colors.green);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ));
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              Firestorefunctions().likePost(
                  user.uid, widget.snap['postId'], widget.snap['likes']);
              if (mounted) {
                setState(() {
                  isLikeAnimating = true;
                });
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    duration: const Duration(microseconds: 400),
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 100,
                    ),
                    onEnd: () {
                      if (mounted) {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                isSmallLike: true,
                child: IconButton(
                  onPressed: () {
                    Firestorefunctions().likePost(
                        user.uid, widget.snap['postId'], widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: primaryColor,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  nextSecreen(
                    context,
                    CommentsScreen(
                      snap: widget.snap,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: primaryColor,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_outline_outlined,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    "${widget.snap['likes'].length} Likes",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "  ${widget.snap['description']}",
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () {
                      nextSecreen(
                        context,
                        CommentsScreen(
                          snap: widget.snap,
                        ),
                      );
                    },
                    child: Text(
                      "View all $comments comments",
                      style:
                          const TextStyle(color: secondaryColor, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 1,
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(
                      DateTime.parse(widget.snap['datePublished']),
                    ),
                    style: const TextStyle(color: secondaryColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
