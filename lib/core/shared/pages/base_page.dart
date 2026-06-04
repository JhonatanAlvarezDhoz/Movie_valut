import 'package:flutter/material.dart';

/// Shell visual reutilizable para pantallas principales.
///
/// La navegación concreta vive en GetX/router; este widget solo compone UI.
class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
