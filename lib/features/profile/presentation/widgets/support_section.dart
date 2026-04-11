import 'package:flutter/material.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/features/profile/presentation/widgets/logouttile.dart';
import 'package:kickoff/features/profile/presentation/widgets/support_bottom_sheet.dart';
import 'package:kickoff/features/profile/presentation/widgets/delete_account_tile.dart'; // added delete account tile

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
    return Column(
      children: [
        ListTile(
          onTap: () => _showSupportSheet(context),
          leading: const Icon(Icons.support_agent, color: ColorsManager.mainColor),
          title: const Text(
            'Support',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: const Text(
            'Contact with support team',
            style: TextStyle(fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(thickness: 0.5, height: 1),
        ),
        const LogoutTile(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(thickness: 0.5, height: 1),
        ),
        const DeleteAccountTile(),
      ],
    );
  }
}
