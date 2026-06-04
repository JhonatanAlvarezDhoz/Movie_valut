import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_valut/core/shared/widgets/custom_text_form_field.dart';
import 'package:movie_valut/core/themes/theme_extensions.dart';
import 'package:movie_valut/core/utils/date_formatter.dart';

/// Campo de fecha reutilizable con selector visual.
///
/// Evita que el usuario tenga que escribir fechas manualmente y mantiene el
/// mismo estilo de los fields compartidos. El controller guarda el texto
/// visible del campo; al seleccionar una fecha se actualiza con formato humano.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.icon = Icons.calendar_month_rounded,
    this.readOnly = false,
    this.enabled = true,
    this.validator,
    this.validators = const [],
    this.padding,
    this.firstDate,
    this.lastDate,
    this.onLockedTap,
    this.onDateSelected,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final List<FormFieldValidator<String>> validators;
  final EdgeInsetsGeometry? padding;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VoidCallback? onLockedTap;
  final ValueChanged<DateTime>? onDateSelected;

  Future<void> _handleTap(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (readOnly) {
      HapticFeedback.selectionClick();
      onLockedTap?.call();
      return;
    }

    if (!enabled) {
      return;
    }

    final now = DateTime.now();
    final resolvedFirstDate = firstDate ?? DateTime(now.year - 120);
    final resolvedLastDate = lastDate ?? now;
    final currentDate = DateFormatter.parseAccountDate(controller.text);
    final initialDate = _clampDate(
      currentDate ?? resolvedLastDate,
      resolvedFirstDate,
      resolvedLastDate,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      builder: (context, child) {
        final colors = context.colors;

        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.theme.colorScheme.copyWith(
              primary: colors.primary,
              onPrimary: Colors.white,
              surface: colors.card,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    controller.text = DateFormatter.toDayMonthYear(selectedDate);
    onDateSelected?.call(selectedDate);
  }

  DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
    if (date.isBefore(firstDate)) {
      return firstDate;
    }

    if (date.isAfter(lastDate)) {
      return lastDate;
    }

    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: CustomTextFormField(
        label: label,
        hintText: hintText,
        controller: controller,
        readOnly: true,
        enabled: enabled,
        validator: validator,
        validators: validators,
        prefixIcon: Icon(icon),
        suffixIcon: const Icon(Icons.expand_more_rounded),
        onTap: () => _handleTap(context),
      ),
    );
  }
}
