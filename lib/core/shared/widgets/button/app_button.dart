import 'package:flutter/material.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const AppLoader(size: 18, strokeWidth: 2)
          : Text(label),
    );
  }
}
