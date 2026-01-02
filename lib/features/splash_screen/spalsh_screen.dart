import 'package:flutter/material.dart';
import 'package:kickoff/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  String _displayedText = '';
  final String _fullText = 'kickoff';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Logo fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      _animateText();
    });

    // Navigate to home after animation completes
    Future.delayed(const Duration(milliseconds: 3500), () {
      _navigateToHome();
    });
  }

  void _animateText() {
    if (_currentIndex < _fullText.length) {
      setState(() {
        _displayedText += _fullText[_currentIndex];
        _currentIndex++;
      });
      Future.delayed(const Duration(milliseconds: 150), _animateText);
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoAnimation,
              child: ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/images/appp_logo.png'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Animated text
            Text(
              _displayedText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
