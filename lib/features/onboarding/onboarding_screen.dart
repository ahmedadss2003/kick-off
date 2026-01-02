import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';

import 'package:kickoff/features/onboarding/custom_button.dart';

import 'onboarding_data.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LogginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingPages[index]['title']!,
                  description: onboardingPages[index]['description']!,
                  image: onboardingPages[index]['image'],
                );
              },
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomBtn(
                text: currentPage == onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: () {
                  currentPage == onboardingPages.length - 1
                      ? completeOnboarding()
                      : nextPage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder HomePage
