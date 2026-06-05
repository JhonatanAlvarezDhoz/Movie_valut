import 'package:flutter/material.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoader(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
