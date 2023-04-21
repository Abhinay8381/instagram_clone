import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_functions.dart';
import 'package:instagram_clone/resources/firestore_functions.dart';
import 'package:instagram_clone/screens/log_in_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String profilePic = "";
  String bio = '';
  int posts = 0, followers = 0, following = 0;
  bool _isLoading = false, _isFollowing = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      QuerySnapshot postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where('uid', isEqualTo: widget.uid)
          .get();
      setState(() {
        username = userSnap['username'];
        bio = userSnap['bio'];
        followers = userSnap['followers'].length;
        following = userSnap['following'].length;
        profilePic = userSnap['profilePic'];
        posts = postSnap.size;
        _isFollowing = userSnap['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(username),
              elevation: 0,
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            backgroundImage: NetworkImage(profilePic),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(posts, 'Posts'),
                                    buildStatColumn(followers, 'Followers'),
                                    buildStatColumn(following, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    widget.uid ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? FollowButton(
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: "Sign Out",
                                            textColor: primaryColor,
                                            onPressed: () async {
                                              await AuthFunctions().signOut();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LogInScreen()),
                                                  (route) => false);
                                            },
                                          )
                                        : _isFollowing == true
                                            ? FollowButton(
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: primaryColor,
                                                text: "Unfollow",
                                                textColor: primaryColor,
                                                onPressed: () async {
                                                  await Firestorefunctions()
                                                      .follow(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);
                                                  setState(() {
                                                    followers--;
                                                    _isFollowing = false;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: blueColor,
                                                borderColor: blueColor,
                                                text: "Follow",
                                                textColor: primaryColor,
                                                onPressed: () async {
                                                  await Firestorefunctions()
                                                      .follow(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);
                                                  setState(() {
                                                    followers++;
                                                    _isFollowing = true;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5, top: 2),
                        child: Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5, top: 2),
                        child: Text(
                          bio,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Image(
                                image: NetworkImage(
                                    snapshot.data!.docs[index]['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    }),
              ],
            ),
          );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 15),
        ),
      ),
    ],
  );
}
