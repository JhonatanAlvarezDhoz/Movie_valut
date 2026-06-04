import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_valut/core/shared/widgets/custom_text.dart';
import 'package:movie_valut/core/themes/theme_extensions.dart';

/// Campo de formulario reusable con una API flexible.
///
/// Vive en `core/shared` porque no pertenece a un feature específico:
/// cualquier módulo puede reutilizarlo conservando el estilo base actual.
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.validators = const [],
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.width,
    this.height,
    this.labelColor,
    this.hintColor,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
  }) : assert(
         controller == null || initialValue == null,
         'No puedes usar controller e initialValue al mismo tiempo.',
       );

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final List<FormFieldValidator<String>> validators;
  final bool enabled;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final double? width;
  final double? height;
  final Color? labelColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedBorderColor = borderColor ?? colors.border;
    final resolvedFocusedBorderColor = focusedBorderColor ?? colors.primary;
    final resolvedErrorBorderColor = errorBorderColor ?? colors.error;
    final resolvedFillColor = fillColor ?? colors.background;
    final resolvedTextColor = textColor ?? colors.textPrimary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width ?? double.infinity,
        minHeight: height ?? 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            style: context.textTheme.bodyMedium,
            color: labelColor ?? colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            initialValue: initialValue,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: textInputAction,
            validator: _composeValidator(),
            enabled: enabled,
            readOnly: readOnly,
            autovalidateMode: autovalidateMode,
            maxLines: obscureText ? 1 : maxLines,
            minLines: obscureText ? 1 : minLines,
            maxLength: maxLength,
            textAlign: textAlign,
            style: TextStyle(color: resolvedTextColor),
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: '',
              filled: true,
              fillColor: resolvedFillColor,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: _buildBorder(resolvedBorderColor),
              enabledBorder: _buildBorder(resolvedBorderColor),
              focusedBorder: _buildBorder(
                resolvedFocusedBorderColor,
                width: 1.4,
              ),
              errorBorder: _buildBorder(resolvedErrorBorderColor),
              focusedErrorBorder: _buildBorder(
                resolvedErrorBorderColor,
                width: 1.4,
              ),
              hintStyle: TextStyle(
                color: hintColor ?? colors.textMuted,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  FormFieldValidator<String>? _composeValidator() {
    if (validator == null && validators.isEmpty) {
      return null;
    }

    return (value) {
      final primaryResult = validator?.call(value);
      if (primaryResult != null) {
        return primaryResult;
      }

      for (final extraValidator in validators) {
        final result = extraValidator(value);
        if (result != null) {
          return result;
        }
      }

      return null;
    };
  }
}
