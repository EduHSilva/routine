import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/app_config.dart';
import '../../view_models/user_viewmodel.dart';
import '../../widgets/custom_appbar.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.id});

  final String id;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _picker = ImagePicker();
  final _userViewModel = UserViewModel();
  File? _imageFile;
  String? _imageBase64;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AppConfig.user;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _loadSavedPhoto(user?.photo);
  }

  Future<void> _loadSavedPhoto(String? photo) async {
    if (photo == null || photo.isEmpty) return;
    try {
      final bytes = base64Decode(photo);
      final directory = await getTemporaryDirectory();
      final image = await File('${directory.path}/profile_${widget.id}.png')
          .writeAsBytes(bytes);
      if (mounted) setState(() => _imageFile = image);
    } on FormatException {
      // A foto antiga pode ser uma URL; nesse caso mantém-se o avatar padrão.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _chooseImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    final image = File(picked.path);
    final encoded = base64Encode(await image.readAsBytes());
    if (mounted) setState(() {
      _imageFile = image;
      _imageBase64 = encoded;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final response = await _userViewModel.updateUser(
      widget.id,
      _nameController.text.trim(),
      _emailController.text.trim(),
      _imageBase64,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      response?.user != null ? 'Perfil atualizado.' : (response?.message
          .isNotEmpty ?? false)
          ? response!.message
          : 'Não foi possível atualizar o perfil.',
    )));
  }

  void _showPhotoOptions() =>
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) =>
            SafeArea(child: Wrap(children: [
              ListTile(leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Escolher da galeria'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _chooseImage(ImageSource.gallery);
                  }),
              ListTile(leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Usar câmera'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _chooseImage(ImageSource.camera);
                  }),
            ])),
      );

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: const CustomAppBar(title: 'Perfil'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(child: Stack(children: [
                  CircleAvatar(radius: 56,
                      backgroundImage: _imageFile == null ? const AssetImage(
                          'assets/images/profile.png') : FileImage(
                          _imageFile!)),
                  Positioned(right: 0,
                      bottom: 0,
                      child: IconButton.filled(tooltip: 'Alterar foto',
                          onPressed: _showPhotoOptions,
                          icon: const Icon(Icons.edit))),
                ])),
                const SizedBox(height: 32),
                TextFormField(controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline)),
                    validator: (value) =>
                    value == null || value
                        .trim()
                        .isEmpty ? 'Informe seu nome.' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined)),
                    validator: (value) =>
                    value == null || !value.contains('@')
                        ? 'Informe um e-mail válido.'
                        : null),
                const SizedBox(height: 28),
                FilledButton.icon(onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: const Text('Salvar alterações')),
              ],
            ),
          ),
        ),
      );
}