import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/features/auth_screen/data/models/register_request.dart';
import 'package:kickoff/features/auth_screen/data/repositories/auth_repository.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/register/cubits/auth_cubit.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/register/cubits/auth_states.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_header.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_auth_button.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_passward.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_textform.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  final passwordController = TextEditingController();
  final firstNmaeController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(AuthRepository(apiConsumer: DioConsumer(dio: Dio()))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Create Account',
              subtitle: 'Join Kickoff today.',
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LogginView()),
                  );
                }
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          lable: 'First Name',
                          controller: firstNmaeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          textInputType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFormField(
                          lable: 'Last Name',
                          controller: lastNameController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          textInputType: TextInputType.name,
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFormField(
                          lable: 'Phone Number',
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },

                          textInputType: TextInputType.phone,
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFormField(
                          lable: 'Email Address',

                          controller: emailController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          textInputType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 14.h),
                        PasswordField(
                          lable: 'Password',

                          controller: passwordController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),
                        PasswordField(
                          lable: 'Confirm Password',
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ConfirmPassword';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        state is AuthLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.mainColor,
                                ),
                              )
                            : CustomAuthButton(
                                text: 'Register',
                                bgColor: ColorsManager.mainColor,
                                elevation: 4,
                                shadowColor: ColorsManager.mainColor
                                    .withOpacity(0.4),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().register(
                                            RegisterRequest(
                                              fname: firstNmaeController.text,
                                              lname: lastNameController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                            ),
                                          );
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
