import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

nextSecreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

nextSecreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  ));
}

imagePick(ImageSource imageSource) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: imageSource);
  if (image != null) {
    return image.readAsBytes();
  }
}
