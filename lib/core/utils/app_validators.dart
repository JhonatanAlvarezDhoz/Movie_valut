abstract final class AppValidators {
  static String? requiredField(
    String? value, {
    String message = 'Este campo es obligatorio.',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(
    String? value, {
    String message = 'Ingresá un correo válido.',
  }) {
    final text = value?.trim() ?? '';
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    return isValid ? null : message;
  }

  static String? minLength(String? value, int length, {String? message}) {
    if ((value ?? '').length < length) {
      return message ?? 'Debe tener al menos $length caracteres.';
    }
    return null;
  }

  static String? compose(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
