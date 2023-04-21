import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  TextEditingController textEditingController;
  bool isPass;
  String hint;
  TextInputType textInputType;
  TextFieldWidget(
      {super.key,
      required this.textEditingController,
      required this.isPass,
      required this.hint,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
