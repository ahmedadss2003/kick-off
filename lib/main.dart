import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/routes_manager/routes_generators.dart';
import 'package:kickoff/features/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
        title: 'KickOff',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkOnboarding();
//   }

//   Future<void> _checkOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

//     if (!mounted) return;

//     if (onboardingCompleted) {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => const LogginView()));
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
