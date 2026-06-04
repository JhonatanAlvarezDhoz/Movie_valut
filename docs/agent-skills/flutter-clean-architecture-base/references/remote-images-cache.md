# Remote image caching

When the app displays remote images, use `cached_network_image` instead of raw `Image.network`.

## Rule

Remote images must be cached and must expose loading/error placeholders.

Preferred package:

```yaml
dependencies:
  cached_network_image: <latest-compatible-version>
```

If the dependency is not installed and the task requires remote images, add it before implementing the UI.

## Architecture rule

Do not scatter `CachedNetworkImage` configuration across features. Create or reuse a shared widget such as:

```txt
lib/core/shared/widgets/images/cached_remote_image.dart
```

The shared widget should centralize:

- image URL rendering;
- placeholder/loading UI;
- error fallback UI;
- border radius/clipping;
- fit/size defaults;
- optional semantic label/accessibility;
- theme-aware background/border.

## What not to do

Avoid:

```dart
Image.network(url)
```

Avoid repeating this in many features:

```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: ...,
  errorWidget: ...,
)
```

Instead, wrap it once in a shared widget and reuse that wrapper.

## Suggested shared widget API

```dart
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
}
```

## Placeholder and error UI

Placeholders must match the app visual language:

- use theme colors;
- keep rounded borders;
- avoid layout jumps by reserving size;
- show a subtle loader/skeleton if needed;
- show a clear fallback icon on error.

## Security and data rules

- Validate nullable/empty URLs before rendering.
- Do not pass tokens in query strings when avoidable.
- If protected images require headers, centralize that behavior in the shared widget/service.
- Do not put image caching decisions in domain entities.

## Agent checklist

Before finishing image UI work:

- [ ] `Image.network` was not used for remote images.
- [ ] `cached_network_image` is installed or explicitly required by the task.
- [ ] A shared image widget is used or created.
- [ ] Placeholder and error states match the theme.
- [ ] Empty/null URLs are handled safely.
- [ ] Image sizing avoids layout jumps.
