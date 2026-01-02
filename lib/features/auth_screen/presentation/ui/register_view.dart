import 'package:flutter/material.dart';

import 'package:kickoff/features/auth_screen/presentation/ui/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static const routeName = '/register';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: RegisterViewBody()),
    );
  }
}
