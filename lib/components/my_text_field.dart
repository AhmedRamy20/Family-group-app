import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final bool obSecure;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.hint,
      required this.obSecure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          // borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hint,
      ),
      obscureText: obSecure,
    );
  }
}
