import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';
import 'package:movie_vault/core/widgets/backgrounds/auth_background.dart';
import 'package:movie_vault/core/widgets/cards/glass_card.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      // Get.toNamed(AppRoutes.splash);
      _authController.checkSessionAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AuthBackground(
        enableScroll: false,
        child: GlassCard(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SplashLogo(),
              SizedBox(height: 8.h),
              Text('Tu catálogo de películas', style: textTheme.bodyMedium),
              SizedBox(height: 20.h),
              const AppLoader(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  static const _assetPath = 'assets/images/icon.png';
  static const _imageWidth = 240.0;

  // El PNG del logo es cuadrado y trae aire transparente interno. Si se renderiza
  // completo, el subtítulo queda visualmente demasiado lejos aunque no haya un
  // spacer grande. Estos ratios recortan el canvas al contenido real del logo.
  static const _contentTopRatio = -20 / 1024;
  static const _contentHeightRatio = (798 - 140) / 1024;

  @override
  Widget build(BuildContext context) {
    final width = _imageWidth.w;

    return SizedBox(
      width: width,
      height: width * _contentHeightRatio,
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(0, -width * _contentTopRatio),
          child: Image.asset(_assetPath, width: width, fit: BoxFit.fitWidth),
        ),
      ),
    );
  }
}
