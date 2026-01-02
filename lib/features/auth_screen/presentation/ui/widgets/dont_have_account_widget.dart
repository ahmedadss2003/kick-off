import 'package:flutter/material.dart';
import 'package:kickoff/core/routes_manager/routes.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';

class DontHaveAccountWidget extends StatelessWidget {
  const DontHaveAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account?', style: TextStyles.font12GrayRegular),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.register);
          },
          child: Text(
            'Sign Up',
            style: TextStyles.font12BlueRegular.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.mainColor,
            ),
          ),
        ),
      ],
    );
  }
}
