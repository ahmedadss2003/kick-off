import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/databases/cache/cache_helper.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/theming/styles.dart';
import 'package:kickoff/core/utils/app_session.dart';
import 'package:kickoff/core/utils/custom_snackbar.dart';
import 'package:kickoff/features/auth_screen/data/models/login_requsest.dart';
import 'package:kickoff/features/auth_screen/data/repositories/auth_repository.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/login/login_cubit.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/login/login_state.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_header.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_auth_button.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_passward.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_textform.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/dont_have_account_widget.dart';
import 'package:kickoff/features/home/home_view.dart';

// ignore: must_be_immutable
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
                  if (state.user.token != null) {
                    AppSession.token = state.user.token;
                    CacheHelper.setData('userToken', state.user.token!);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                }
                if (state is LoginFailure) {
                  showCustomSnackBar(
                    context: context,
                    message: state.error,
                    color: Colors.red,
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
