import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_textform.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.lable,
    required this.validator,
    this.controller,
  });

  final void Function(String?)? onSaved;
  final String lable;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      obscureText: obscureText,
      onSaved: widget.onSaved,
      lable: widget.lable,
      validator: widget.validator,
      controller: widget.controller,
      textInputType: TextInputType.visiblePassword,
      suffixIcon: GestureDetector(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: Icon(
          color: const Color(0xffC9CECF),
          obscureText ? Icons.remove_red_eye : Icons.visibility_off,
        ),
      ),
    );
  }
}
