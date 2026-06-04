import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_vault/core/shared/widgets/custom_text_form_field.dart';

/// Campo de contraseña reutilizable para formularios de cuenta.
///
/// Mantiene internamente el estado de visibilidad para no repetir esa lógica en
/// cada pantalla que necesite capturar passwords.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.readOnly = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.validators = const [],
    this.padding,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool readOnly;
  final bool enabled;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final List<FormFieldValidator<String>> validators;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: CustomTextFormField(
        label: widget.label,
        hintText: widget.hintText,
        controller: widget.controller,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        validator: widget.validator,
        validators: widget.validators,
        obscureText: _obscureText,
        textInputAction: widget.textInputAction,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: widget.enabled
              ? () {
                  setState(() => _obscureText = !_obscureText);
                }
              : null,
          icon: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility,
          ),
        ),
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
