import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  Function()? onPressed;
  final Color backgroundColor, borderColor;
  final String text;
  final Color textColor;

  FollowButton(
      {super.key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          width: 200,
          height: 27,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
