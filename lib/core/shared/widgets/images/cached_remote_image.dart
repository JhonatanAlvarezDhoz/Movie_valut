import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';

/// Wrapper único para imágenes remotas cacheadas.
///
/// Regla de arquitectura: las features no usan `Image.network` directamente.
class CachedRemoteImage extends StatelessWidget {
  const CachedRemoteImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final hasUrl = imageUrl.trim().isNotEmpty;

    Widget child;
    if (!hasUrl) {
      child = _ImageFallback(width: width, height: height);
    } else {
      child = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: const Center(child: AppLoader(size: 22, strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) =>
            _ImageFallback(width: width, height: height),
      );
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: ClipRRect(borderRadius: radius, child: child),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
