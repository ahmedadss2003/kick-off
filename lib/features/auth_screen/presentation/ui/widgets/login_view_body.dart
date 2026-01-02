import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_header.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_auth_button.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/dont_have_account_widget.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/labeled_auth_text_field.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/social_login_button.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  bool isPasswordObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AuthHeader(
            title: 'Kickoff',
            subtitle: 'Book your match in seconds.',
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
                  SizedBox(height: 12.h),

                  LabeledAuthTextField(
                    label: 'Password',
                    hintText: 'Enter password',
                    isObscureText: isPasswordObscure,
                    textInputAction: TextInputAction.done,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyles.font12BlueRegular.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CustomAuthButton(
                    text: "Log In",
                    bgColor: ColorsManager.mainColor,
                    elevation: 4,
                    shadowColor: ColorsManager.mainColor.withOpacity(0.4),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Perform login.
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  DontHaveAccountWidget(),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyles.font12GrayMedium.copyWith(
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  SocialLoginButton(
                    onPressed: () {
                      // Perform Google login
                    },
                    label: 'Continue with Google',
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                      height: 24.h,
                    ),
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
