import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/build_headder.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BuildHeadder(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 54.h),
              if (title == 'Kickoff') ...[
                Text('Welcome to', style: TextStyles.font24BlackBold),
                Text(
                  'Kickoff',
                  style: TextStyles.font24BlackBold.copyWith(
                    fontSize: 28.sp,
                    color: ColorsManager.mainColor,
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
