import 'package:get/get.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';
import 'package:movie_vault/features/auth/domain/usecases/get_current_session_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/logout_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/reset_password_use_case.dart';

class AuthController extends GetxController {
  AuthController({
    required LoginUserUseCase loginUserUseCase,
    required RegisterUserUseCase registerUserUseCase,
    required LogoutUserUseCase logoutUserUseCase,
    required GetCurrentSessionUseCase getCurrentSessionUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _loginUserUseCase = loginUserUseCase,
       _registerUserUseCase = registerUserUseCase,
       _logoutUserUseCase = logoutUserUseCase,
       _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _resetPasswordUseCase = resetPasswordUseCase;

  final LoginUserUseCase _loginUserUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  final isSubmitting = false.obs;
  final isCheckingSession = false.obs;
  final errorMessage = RxnString();
  final successMessage = RxnString();
  final session = Rxn<AuthSession>();

  void clearTransientState() {
    errorMessage.value = null;
    successMessage.value = null;
    isSubmitting.value = false;
  }

  Future<void> checkSessionAndRedirect() async {
    isCheckingSession.value = true;
    errorMessage.value = null;

    final result = await _getCurrentSessionUseCase();
    isCheckingSession.value = false;

    switch (result) {
      case ResultSuccess(value: final currentSession):
        session.value = currentSession;
        Get.offAllNamed(
          currentSession == null ? AppRoutes.login : AppRoutes.home,
        );
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
        Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> login({required String email, required String password}) async {
    isSubmitting.value = true;
    errorMessage.value = null;

    final result = await _loginUserUseCase(email: email, password: password);
    isSubmitting.value = false;

    switch (result) {
      case ResultSuccess(value: final authSession):
        session.value = authSession;
        Get.offAllNamed(AppRoutes.home);
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    isSubmitting.value = true;
    errorMessage.value = null;

    final result = await _registerUserUseCase(email: email, password: password);
    isSubmitting.value = false;

    switch (result) {
      case ResultSuccess(value: final authSession):
        session.value = authSession;
        Get.offAllNamed(AppRoutes.home);
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }

  Future<void> logout() async {
    isSubmitting.value = true;
    errorMessage.value = null;

    final result = await _logoutUserUseCase();
    isSubmitting.value = false;

    switch (result) {
      case ResultSuccess():
        session.value = null;
        Get.offAllNamed(AppRoutes.login);
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }

  Future<void> resetPassword(String email) async {
    isSubmitting.value = true;
    errorMessage.value = null;
    successMessage.value = null;

    final result = await _resetPasswordUseCase(email);
    isSubmitting.value = false;

    switch (result) {
      case ResultSuccess():
        successMessage.value =
            'Te enviamos un correo para restablecer tu contraseña.';
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }
}
