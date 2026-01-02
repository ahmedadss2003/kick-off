import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_header.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_auth_button.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/labeled_auth_text_field.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AuthHeader(
            title: 'Create Account',
            subtitle: 'Join Kickoff today.',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  LabeledAuthTextField(
                    label: 'Full Name',
                    hintText: 'Enter your name',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: ColorsManager.mainBlue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14.h),
                  LabeledAuthTextField(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: ColorsManager.mainBlue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14.h),
                  LabeledAuthTextField(
                    label: 'Password',
                    hintText: 'Enter password',
                    isObscureText: isPasswordObscure,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: ColorsManager.mainBlue,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordObscure = !isPasswordObscure;
                        });
                      },
                      icon: Icon(
                        isPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorsManager.gray,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14.h),
                  LabeledAuthTextField(
                    label: 'Confirm Password',
                    hintText: 'Confirm password',
                    isObscureText: isConfirmPasswordObscure,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: ColorsManager.mainBlue,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordObscure = !isConfirmPasswordObscure;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorsManager.gray,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 48.h),
                  CustomAuthButton(
                    text: 'Register',
                    bgColor: ColorsManager.mainColor,
                    elevation: 4,
                    shadowColor: ColorsManager.mainColor.withOpacity(0.4),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Perform registration
                      }
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyles.font13GrayRegular,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Log In',
                          style: TextStyles.font13BlueSemiBold.copyWith(
                            color: ColorsManager.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
