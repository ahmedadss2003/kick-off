import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Widget icon;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: ColorsManager.lighterGray),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          foregroundColor: ColorsManager.darkBlue,
          elevation: 0,
        ),
        icon: icon,
        label: Text(label, style: TextStyles.font14DarkBlueMedium),
      ),
    );
  }
}
