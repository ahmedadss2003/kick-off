import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/profile/data/services/logout_service.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red, size: 26),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await LogoutService(Dio()).logout();
      } catch (_) {}

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LogginView()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _handleLogout(context),
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: Colors.red,
      ),
    );
  }
}
