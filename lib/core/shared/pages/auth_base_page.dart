import 'package:flutter/material.dart';
import 'package:movie_vault/core/shared/widgets/responsive_page_container.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsivePageContainer(
        children: [
          const SizedBox(height: 32),
          Text(
            'Movie Vault',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
