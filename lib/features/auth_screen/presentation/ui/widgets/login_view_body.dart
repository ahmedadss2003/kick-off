import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/data/models/login_requsest.dart';
import 'package:kickoff/features/auth_screen/data/repositories/auth_repository.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/login/login_cubit.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/login/login_state.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_header.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_auth_button.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_passward.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_textform.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/dont_have_account_widget.dart';
import 'package:kickoff/features/test/testfile.dart';

class LoginViewBody extends StatelessWidget {
  LoginViewBody({super.key});

  bool isPasswordObscure = true;

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(AuthRepository(apiConsumer: DioConsumer(dio: Dio()))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Kickoff',
              subtitle: 'Book your match in seconds.',
            ),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TestFile()),
                  );
                }
                if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),
                        CustomTextFormField(
                          controller: emailController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          lable: 'Email',
                          textInputType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12.h),

                        PasswordField(
                          controller: passwordController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          lable: 'Password',
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
                        state is LoginLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.mainColor,
                                ),
                              )
                            : CustomAuthButton(
                                text: "Log In",
                                bgColor: ColorsManager.mainColor,
                                elevation: 4,
                                shadowColor: ColorsManager.mainColor
                                    .withOpacity(0.4),
                                onPressed: state is LoginLoading
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                            LoginRequest(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                              ),
                        SizedBox(height: 16.h),
                        DontHaveAccountWidget(),
                        SizedBox(height: 18.h),
                        // Row(
                        //   children: [
                        //     const Expanded(child: Divider()),
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 16.w),
                        //       child: Text(
                        //         'OR CONTINUE WITH',
                        //         style: TextStyles.font12GrayMedium.copyWith(
                        //           letterSpacing: 1.2,
                        //         ),
                        //       ),
                        //     ),
                        //     const Expanded(child: Divider()),
                        //   ],
                        // ),
                        // SizedBox(height: 32.h),
                        // SocialLoginButton(
                        //   onPressed: () {
                        //     // Perform Google login
                        //   },
                        //   label: 'Continue with Google',
                        //   icon: Image.network(
                        //     'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                        //     height: 24.h,
                        //   ),
                        // ),
                        // SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
