import 'package:flutter/material.dart';

class OnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingIndicators({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}