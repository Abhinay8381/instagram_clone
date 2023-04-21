import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_functions.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _image;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  _addImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagePick(ImageSource.camera);
                  setState(() {
                    _image = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Upload from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagePick(ImageSource.gallery);
                  setState(() {
                    _image = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearScreen() {
    setState(() {
      _image = null;
    });
  }

  void postImage(String uid, String profPic, String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Firestorefunctions()
          .uploadPost(
              uid, _descriptionController.text, _image!, username, profPic)
          .then((value) {
        if (value == "Success") {
          showSnackBar(context, "Posted!", Colors.green);
          setState(() {
            _isLoading = false;
          });
          clearScreen();
        } else {
          showSnackBar(context, value, Colors.red);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.red);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    return _image == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: primaryColor,
              ),
              onPressed: () {
                _addImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.profilePic, user.username),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                ),
                onPressed: () {
                  clearScreen();
                },
              ),
            ),
            body: Column(
              children: [
                _isLoading == true
                    ? const LinearProgressIndicator(
                        color: blueColor,
                      )
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a Caption.....",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_image!),
                              alignment: FractionalOffset.topCenter,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
