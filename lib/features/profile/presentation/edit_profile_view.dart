import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/core/utils/app_session.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_text_form_field.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import 'package:kickoff/features/profile/data/services/update_profile.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  File? _pickedImage;
  bool _isUploadingImage = false;
  late String _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.mobileNumber);
    _currentImageUrl = widget.user.image.isNotEmpty
        ? widget.user.image
        : (AppSession.cachedImageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
      _isUploadingImage = true;
    });

    try {
      final newUrl = await UpdateProfileService.updateProfileImage(
        imageFile: _pickedImage!,
        name: _nameController.text.trim(),
        mobileNumber: _phoneController.text.trim(),
      );

      setState(() => _currentImageUrl = newUrl);
      
      if (mounted) {
        // Option to trigger a profile refresh via Cubit so it reflects globally
        context.read<ProfileCubit>().updateProfileImageLocally(newUrl); 
        
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
        setState(() => _pickedImage = null);
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  ImageProvider _resolveImage() {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    if (_currentImageUrl.isNotEmpty) return NetworkImage(_currentImageUrl);
    return const AssetImage('assets/images/default_avatar.png');
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateUserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdateLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _resolveImage(),
                          ),
                          if (_isUploadingImage)
                            const Positioned.fill(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black45,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          if (!_isUploadingImage)
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickAndUploadImage,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.mainColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                            ),
                        ],
                      ),
                    ).animate().fade().scale(curve: Curves.easeOutBack),

                    const SizedBox(height: 30),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fade(duration: 400.ms).slideX(),
                    const SizedBox(height: 20),
                    
                    AuthTextFormField(
                      hintText: 'Full Name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your name' : null,
                    ).animate().fade(delay: 200.ms).slideY(),
                    
                    const SizedBox(height: 16),
                    
                    AuthTextFormField(
                      hintText: 'Email Address',
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!value.contains('@')) return 'Invalid email address';
                        return null;
                      },
                    ).animate().fade(delay: 400.ms).slideY(),
                    
                    const SizedBox(height: 16),
                    
                    AuthTextFormField(
                      hintText: 'Phone Number',
                      controller: _phoneController,
                      prefixIcon: const Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your phone number' : null,
                    ).animate().fade(delay: 600.ms).slideY(),
                    
                    const SizedBox(height: 32),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.mainColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: isLoading || _isUploadingImage ? null : _saveProfile,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ).animate().fade(delay: 800.ms).scale(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

