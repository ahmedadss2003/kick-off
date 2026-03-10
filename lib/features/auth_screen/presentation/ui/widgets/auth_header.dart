import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const BuildHeadder(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 54.h),
              if (title == 'Kickoff' || title == 'KickOff') ...[
                Text('Welcome to', style: TextStyles.font24BlackBold),
                RichText(
                  text: TextSpan(
                    style: TextStyles.font24BlackBold.copyWith(fontSize: 28.sp),
                    children: [
                      TextSpan(
                        text: 'K',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 5, 215, 26),
                          fontSize: 36.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'ick',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 112, 4),
                          fontSize: 36.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'off',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 138, 127, 2),
                          fontSize: 36.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(title, style: TextStyles.font24BlackBold),
              ],
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle!,
                  style: TextStyles.font14GrayRegular,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
