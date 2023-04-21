import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_functions.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/userful_functions.dart';
import 'package:instagram_clone/widgets/text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void logIn() async {
    setState(() {
      _isLoading = true;
    });
    AuthFunctions()
        .logInUser(email: _emailController.text, password: _passController.text)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == "Success") {
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
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 64,
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
            InkWell(
              onTap: () {
                logIn();
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
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text("Don't have an account?"),
                ),
                GestureDetector(
                  onTap: () {
                    nextSecreen(context, const SignUpScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      "Sign up",
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
      )),
    );
  }
}
