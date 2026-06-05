import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/pages/auth_base_page.dart';
import 'package:movie_vault/core/shared/widgets/button/app_button.dart';
import 'package:movie_vault/core/shared/widgets/custom_text_form_field.dart';
import 'package:movie_vault/core/shared/widgets/feedback/app_error_view.dart';
import 'package:movie_vault/core/shared/widgets/fields/password_field.dart';
import 'package:movie_vault/core/utils/app_validators.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.clearTransientState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBasePage(
      children: [
        Text('Creá tu cuenta', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Firebase Authentication se encarga del registro remoto.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _emailController,
                label: 'Correo',
                hintText: 'name@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => AppValidators.compose(value, [
                  AppValidators.requiredField,
                  AppValidators.email,
                ]),
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _passwordController,
                label: 'Contraseña',
                hintText: 'Mínimo 6 caracteres',
                textInputAction: TextInputAction.done,
                validator: (value) => AppValidators.compose(value, [
                  AppValidators.requiredField,
                  (text) => AppValidators.minLength(text, 6),
                ]),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isSubmitting = _authController.isSubmitting.value;
                final error = _authController.errorMessage.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (error != null) ...[
                      AppErrorView(message: error, compact: true),
                      const SizedBox(height: 12),
                    ],
                    AppButton(
                      label: 'Registrarme',
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _authController.clearTransientState();
                  Get.back<void>();
                },
                child: const Text('Ya tengo cuenta'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
