import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled(
      {super.key,
        required this.controller,
        this.validator,
        this.toHide = false,
        required this.iconData,
        this.onChanged,
        required this.hint});

  final TextEditingController controller;
  final bool toHide;
  final IconData iconData;
  final String? Function(String? value)? validator;
  final String hint;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: toHide,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
