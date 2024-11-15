import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routine/widgets/custom_appbar.dart';
import 'package:routine/widgets/custom_button.dart';
import 'package:routine/widgets/custom_drawer.dart';
import 'package:routine/widgets/custom_text_field.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  String userName = "Nome do Usuário";
  File? _imageFile;
  String? _imageBase64;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Método para pegar a imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBase64 = base64Encode(_imageFile!.readAsBytesSync());
      });
    }
  }

  // Método para pegar a imagem da câmera
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
              prefixIcon: Icons.person_off_outlined,
              controller: _nameController,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              prefixIcon: Icons.email_outlined,
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'save', onPressed: _save)
          ],
        ),
      ),
    );
  }

  void _save(){}

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecionar Foto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeria"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Câmera"),
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
