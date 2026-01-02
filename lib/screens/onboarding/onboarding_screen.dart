import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/onboarding/onboarding_data.dart';
import 'package:kickoff/features/onboarding/onboarding_page.dart';
import 'package:kickoff/features/onboarding/onboarding_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    // Navigate to home
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LogginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingPages[index]['title']!,
                description: onboardingPages[index]['description']!,
                icon: onboardingPages[index]['icon'] as IconData,
              );
            },
          ),
          Positioned(
            top: 50,
            right: 16,
            child: TextButton(onPressed: _skip, child: const Text('Skip')),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingIndicators(
                  currentPage: _currentPage,
                  pageCount: onboardingPages.length,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
