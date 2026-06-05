import 'package:get/get.dart';
import 'package:movie_vault/core/constants/keys/storage_keys.dart';
import 'package:movie_vault/core/storage/services/app_storage_service.dart';
import 'package:movie_vault/core/themes/app_theme_mode.dart';

/// Global controller for the app theme mode.
///
/// The UI only toggles light/dark. Persistence stays in core storage so feature
/// pages do not know about SharedPreferences.
class ThemeController extends GetxController {
  ThemeController(this._storage)
    : mode = appThemeModeFromStorage(
        _storage.getString(StorageKeys.themeMode),
      ).obs;

  final AppStorageService _storage;
  final Rx<AppThemeMode> mode;

  bool get isDarkMode => mode.value == AppThemeMode.dark;

  Future<void> toggleDarkMode({required bool enabled}) async {
    final nextMode = enabled ? AppThemeMode.dark : AppThemeMode.light;
    mode.value = nextMode;
    Get.changeThemeMode(nextMode.themeMode);
    await _storage.saveString(StorageKeys.themeMode, nextMode.storageValue);
  }
}
