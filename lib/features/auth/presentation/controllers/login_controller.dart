import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  static LoginController get to => Get.find<LoginController>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<void> login(String email, String password, {required VoidCallback onSuccess}) async {
    isLoading = true;
    try {
      final params = LoginParams(email: email, password: password);
      final result = await _loginUseCase.call(params);
      if (result.isSuccess) {
        onSuccess();
      } else {
        Get.snackbar('Error', result.error ?? 'Login failed');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading = false;
    }
  }
}
