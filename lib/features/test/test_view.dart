import 'package:flutter/material.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D1117),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science_outlined, color: Colors.white38, size: 64),
            SizedBox(height: 16),
            Text(
              'Test',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'هنا هتيجي المحتوى بتاع الـ Test',
              style: TextStyle(color: Colors.white30, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
