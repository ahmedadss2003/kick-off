import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickoff/core/utils/app_session.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import 'package:kickoff/features/profile/data/services/update_profile.dart';

class PersonalDataInfo extends StatefulWidget {
  const PersonalDataInfo({super.key, required this.user});
  final UserProfileModel user;

  @override
  State<PersonalDataInfo> createState() => _PersonalDataInfoState();
}

class _PersonalDataInfoState extends State<PersonalDataInfo> {
  File? _pickedImage;
  bool _isUploading = false;
  late String _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.user.image.isNotEmpty
        ? widget.user.image
        : (AppSession.cachedImageUrl ?? '');
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
      _isUploading = true;
    });

    try {
      final newUrl = await UpdateProfileService.updateProfileImage(
        imageFile: _pickedImage!,
        name: widget.user.name,
        // email: widget.user.email,
        mobileNumber: widget.user.mobileNumber,
      );

      setState(() => _currentImageUrl = newUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _pickedImage = null); // revert
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  ImageProvider _resolveImage() {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    if (_currentImageUrl.isNotEmpty) return NetworkImage(_currentImageUrl);
    return const AssetImage(
      'assets/images/default_avatar.png',
    ); // your fallback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: _resolveImage(),
                  ),
                ),
              ),
              if (_isUploading)
                const Positioned.fill(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.black26,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              if (!_isUploading)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _buildInfoChip(
              icon: Icons.alternate_email,
              label: widget.user.email,
              color: Colors.blue.withOpacity(0.1),
              iconColor: Colors.blue,
            ),
            _buildInfoChip(
              icon: Icons.phone_android,
              label: widget.user.mobileNumber,
              color: Colors.green.withOpacity(0.1),
              iconColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: iconColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
