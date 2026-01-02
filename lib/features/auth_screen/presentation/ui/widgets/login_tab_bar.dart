import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';

class LoginTabBar extends StatelessWidget {
  const LoginTabBar({
    super.key,
    required this.onEmailTap,
    required this.onPhoneTap,
    required this.isEmailSelected,
  });
  final bool isEmailSelected;
  final VoidCallback onEmailTap;
  final VoidCallback onPhoneTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: ColorsManager.lighterGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isEmailSelected
                ? Alignment.centerRight
                : Alignment.centerLeft,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 42.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onPhoneTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Phone',
                      style: isEmailSelected
                          ? TextStyles.font14GrayRegular
                          : TextStyles.font14DarkBlueBold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onEmailTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Email',
                      style: isEmailSelected
                          ? TextStyles.font14DarkBlueBold
                          : TextStyles.font14GrayRegular,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
