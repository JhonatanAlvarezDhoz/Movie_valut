import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_vault/core/shared/widgets/custom_text.dart';
import 'package:movie_vault/core/extensions/context_theme_extension.dart';

/// Opción simple para dropdowns compartidos.
///
/// [value] es lo que se guarda/envía; [label] es lo que ve el usuario.
class DropdownFieldOption {
  const DropdownFieldOption({required this.value, required this.label});

  final String value;
  final String label;
}

/// Dropdown con el mismo lenguaje visual de los fields compartidos.
///
/// Usa un [TextEditingController] para integrarse con formularios existentes:
/// al seleccionar una opción, el controller recibe el `value` canónico.
class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.options,
    this.icon,
    this.readOnly = false,
    this.enabled = true,
    this.validator,
    this.validators = const [],
    this.padding,
    this.onLockedTap,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<DropdownFieldOption> options;
  final IconData? icon;
  final bool readOnly;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final List<FormFieldValidator<String>> validators;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onLockedTap;
  final ValueChanged<String>? onChanged;

  void _handleLockedTap() {
    if (!readOnly) {
      return;
    }

    HapticFeedback.selectionClick();
    onLockedTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedValue = _resolveSelectedValue();
    final canSelect = enabled && !readOnly;

    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: readOnly ? _handleLockedTap : null,
        child: AbsorbPointer(
          absorbing: readOnly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                style: context.appTextTheme.bodyMedium,
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                initialValue: selectedValue,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18.r),
                menuMaxHeight: 320.h,
                elevation: 8,
                items: options
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option.value,
                        child: Text(
                          option.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: canSelect
                    ? (value) {
                        if (value == null) {
                          return;
                        }

                        controller.text = value;
                        onChanged?.call(value);
                      }
                    : null,
                validator: _composeValidator(),
                dropdownColor: colors.card,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colors.textSecondary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: colors.background,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  prefixIcon: icon == null ? null : Icon(icon),
                  border: _buildBorder(colors.border),
                  enabledBorder: _buildBorder(colors.border),
                  focusedBorder: _buildBorder(colors.primary, width: 1.4),
                  errorBorder: _buildBorder(colors.error),
                  focusedErrorBorder: _buildBorder(colors.error, width: 1.4),
                  hintStyle: TextStyle(
                    color: colors.textMuted,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _resolveSelectedValue() {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }

    final hasExactMatch = options.any((option) => option.value == value);
    if (hasExactMatch) {
      return value;
    }

    final labelMatch = options.where((option) => option.label == value);
    if (labelMatch.isNotEmpty) {
      return labelMatch.first.value;
    }

    return null;
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
