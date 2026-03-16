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
        email: widget.user.email,
        mobileNumber: widget.user.mobileNumber,
      );

      // Update the displayed URL with fresh one from API
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
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shadowColor: Colors.white,
        color: const Color.fromARGB(255, 221, 221, 221),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _resolveImage(),
                  ),
                  if (_isUploading)
                    const Positioned.fill(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black45,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (!_isUploading)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickAndUploadImage,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, color: Colors.black, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    widget.user.mobileNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 109, 109, 109),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
