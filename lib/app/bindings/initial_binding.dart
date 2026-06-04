import 'package:get/get.dart';

/// Binding inicial de GetX.
///
/// Los controladores de features se registrarán en sus bindings específicos para
/// no convertir el arranque de la app en un contenedor global gigante.
class InitialBinding extends Bindings {
  @override
  void dependencies() {}
}
