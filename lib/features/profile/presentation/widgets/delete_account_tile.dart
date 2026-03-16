import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key});

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 26),
            SizedBox(width: 8),
            Text('Delete Account', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
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
            child: const Text('Delete'),
          ),
        ],
      ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
    );

    if (confirmed == true && context.mounted) {
      context.read<ProfileCubit>().deleteUserAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDeleteLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileDeleteSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LogginView()),
            (route) => false,
          );
        } else if (state is ProfileDeleteFailure) {
          Navigator.of(context).pop(); // remove loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: ListTile(
        onTap: () => _handleDelete(context),
        leading: const Icon(Icons.delete_forever, color: Colors.red),
        title: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.red,
        ),
      ),
    );
  }
}
