import 'package:routine/views/auth/register_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../config/design_system.dart';
import '../../config/helper.dart';
import '../../models/user/login_model.dart';
import '../../view_models/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthViewModel _authViewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _login() async {
    if (!_validateForm()) return;

    try {
      LoginResponse? response = await _authViewModel.login(
          _usernameController.text, _passwordController.text);
      _handleResponse(response);
    } catch (error) {
      //
    }
  }

  void _handleResponse(LoginResponse? response) {
    if (response?.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _authViewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Text(
                            'login'.tr(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        CustomTextField(
                          labelText: 'email'.tr(),
                          controller: _usernameController,
                          validator: requiredFieldValidator,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          isPassword: true,
                          labelText: 'password'.tr(),
                          controller: _passwordController,
                          validator: requiredFieldValidator,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: Column(
                            children: [
                              CustomButton(
                                text: 'login'.tr(),
                                onPressed: _login,
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const RegisterView(),
                                  ));
                                },
                                text: 'signUp'.tr(),
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implementar a lógica para recuperar a senha
                          },
                          child: Text('lostPassword'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
