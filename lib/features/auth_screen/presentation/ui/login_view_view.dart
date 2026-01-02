import 'package:flutter/material.dart';

import 'package:kickoff/features/auth_screen/presentation/ui/widgets/login_view_body.dart';

class LogginView extends StatelessWidget {
  const LogginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: LoginViewBody()),
    );
  }
}
