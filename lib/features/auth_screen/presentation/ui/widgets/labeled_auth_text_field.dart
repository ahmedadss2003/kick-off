import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_text_form_field.dart';

class LabeledAuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const LabeledAuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isObscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.font14DarkBlueBold),
        SizedBox(height: 8.h),
        AuthTextFormField(
          hintText: hintText,
          isObscureText: isObscureText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
