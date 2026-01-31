import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.lable,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.validator,
    this.controller,
  });

  final String lable;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Function(String?)? onSaved;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Use controller
      obscureText: obscureText,
      onSaved: onSaved,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        label: Text(lable),
        filled: true,
        fillColor: const Color(0xfff9fafa),
        border: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildFocusedOutlineInputBorder(),
      ),
    );
  }

  OutlineInputBorder buildFocusedOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(19),
      borderSide: const BorderSide(width: 1.5, color: Colors.teal),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(19),

      borderSide: const BorderSide(width: 1, color: Colors.white),
    );
  }
}
