import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../view_models/user_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_text_field.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.id});

  final int id;

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  File? _imageFile;
  String? _imageBase64;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final UserViewModel _userViewModel = UserViewModel();

  @override
  void initState() {
    super.initState();
    _userViewModel.getUser(widget.id).then((r) async {
      _nameController.text = r!.user!.name;
      _emailController.text = r.user!.email;

      if (r.user!.photo!.isNotEmpty) {
        final bytes = base64Decode(r.user!.photo!);
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/user_image.png';
        _imageFile = await File(imagePath).writeAsBytes(bytes);
      }

      setState(() {});
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBase64 = base64Encode(_imageFile!.readAsBytesSync());
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBase64 = base64Encode(_imageFile!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _userViewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: CustomAppBar(title: "profile"),
              drawer: CustomDrawer(currentRoute: "/profile"),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showImagePickerDialog(context),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/images/profile.png')
                                as ImageProvider,
                        child: _imageFile == null
                            ? const Icon(Icons.camera_alt,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      prefixIcon: Icons.person_off_outlined,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(text: 'save', onPressed: _save)
                  ],
                ),
              ),
            );
          }
        });
  }

  void _save() {
    _userViewModel.updateUser(
      widget.id,
      _nameController.text,
      _emailController.text,
      _imageBase64
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("selectPhoto".tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text("phone".tr()),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("cam".tr()),
                onTap: () {
                  Navigator.of(context).pop();
                  _captureImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
