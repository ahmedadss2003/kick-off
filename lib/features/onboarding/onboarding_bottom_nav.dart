import 'package:flutter/material.dart';
import 'onboarding_indicators.dart';

class OnboardingBottomNav extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final int currentPage;
  final int totalPages;

  const OnboardingBottomNav({
    super.key,
    required this.onSkip,
    required this.onNext,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: onSkip, child: const Text('Skip')),
          OnboardingIndicators(
            currentPage: currentPage,
            pageCount: totalPages,
          ),
          ElevatedButton(
            onPressed: onNext,
            child: Text(
              currentPage == totalPages - 1 ? 'Get Started' : 'Next',
            ),
          ),
        ],
      ),
    );
  }
}