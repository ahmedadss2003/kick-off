import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/profile/data/services/logout_service.dart';
import 'package:kickoff/features/profile/presentation/widgets/logouttile.dart';
import 'package:kickoff/features/profile/presentation/widgets/support_bottom_sheet.dart';

class SupportAndLogoutSection extends StatelessWidget {
  const SupportAndLogoutSection({super.key});

  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SupportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 221, 221, 221),
        child: Column(
          children: [
            ListTile(
              onTap: () => _showSupportSheet(context),
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              subtitle: const Text(
                'Contact with support team',
                style: TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: const Divider(
                thickness: 0.3,
                color: Color.fromARGB(255, 19, 19, 19),
              ),
            ),
            const LogoutTile(),
          ],
        ),
      ),
    );
  }
}
