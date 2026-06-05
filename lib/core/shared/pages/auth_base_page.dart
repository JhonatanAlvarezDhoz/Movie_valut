import 'package:flutter/material.dart';
import 'package:movie_vault/core/themes/app_colors.dart';
import 'package:movie_vault/core/widgets/backgrounds/auth_background.dart';
import 'package:movie_vault/core/widgets/cards/glass_card.dart';

class AuthBasePage extends StatelessWidget {
  const AuthBasePage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _MovieVaultWordmark(),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieVaultWordmark extends StatelessWidget {
  const _MovieVaultWordmark();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: -1.2,
      height: 1,
      shadows: [
        Shadow(
          color: colors.background.withValues(alpha: 0.45),
          offset: const Offset(0, 3),
          blurRadius: 8,
        ),
      ],
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Movie ', style: baseStyle?.copyWith(color: colors.textPrimary)),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.primary,
                Color.lerp(colors.primary, colors.primarySoft, 0.45)!,
              ],
            ).createShader(bounds),
            child: Text('Vault', style: baseStyle),
          ),
        ],
      ),
    );
  }
}
