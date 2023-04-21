import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_functions.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void pickImage() async {
    Uint8List im = await imagePick(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    AuthFunctions()
        .resgisterUser(
            email: _emailController.text,
            password: _passController.text,
            bio: _bioController.text,
            username: _usernameController.text,
            file: _image!)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == 'Success') {
        showSnackBar(context, value, Colors.green);
        nextSecreenReplacement(
            context,
            ResponsiveLayout(
                webScreenLayout: const WebScreenlayout(),
                mobileScreenLayout: const MobileScreenLayout()));
      } else {
        showSnackBar(context, value, Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          backgroundImage: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/innstagram-clone.appspot.com/o/account_circle.png?alt=media&token=c9a830b0-5979-4e06-a5cf-56f313bbb65f"),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 65,
                      child: IconButton(
                          onPressed: () {
                            pickImage();
                          },
                          icon: const Icon(Icons.add_a_photo))),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              TextFieldWidget(
                hint: 'Enter your username',
                textEditingController: _usernameController,
                textInputType: TextInputType.text,
                isPass: false,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                hint: 'Enter your email',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
                isPass: false,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                hint: 'Enter password',
                textEditingController: _passController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                hint: 'Bio',
                textEditingController: _bioController,
                textInputType: TextInputType.text,
                isPass: false,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  signUp();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text("Already have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      )),
    );
  }
}
