import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/pages/auth_base_page.dart';
import 'package:movie_vault/core/shared/widgets/button/app_button.dart';
import 'package:movie_vault/core/shared/widgets/custom_text_form_field.dart';
import 'package:movie_vault/core/shared/widgets/feedback/app_error_view.dart';
import 'package:movie_vault/core/utils/app_validators.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.clearTransientState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _authController.resetPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AuthBasePage(
      children: [
        Text(
          'Recuperá tu contraseña',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresá tu correo y te enviaremos un enlace para restablecerla.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                controller: _emailController,
                label: 'Correo',
                hintText: 'name@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) => AppValidators.compose(value, [
                  AppValidators.requiredField,
                  AppValidators.email,
                ]),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isSubmitting = _authController.isSubmitting.value;
                final error = _authController.errorMessage.value;
                final success = _authController.successMessage.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (error != null) ...[
                      AppErrorView(message: error, compact: true),
                      const SizedBox(height: 12),
                    ],
                    if (success != null) ...[
                      _ResetPasswordSuccessMessage(message: success),
                      const SizedBox(height: 12),
                    ],
                    AppButton(
                      label: 'Enviar enlace',
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
                child: const Text('Volver al inicio de sesión'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordSuccessMessage extends StatelessWidget {
  const _ResetPasswordSuccessMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.mark_email_read_outlined, color: colors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
