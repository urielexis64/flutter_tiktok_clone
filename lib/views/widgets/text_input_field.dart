import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.icon,
      this.isObscure = false})
      : super(key: key);

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 20),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
