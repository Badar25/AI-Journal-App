import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '/features/auth/domain/usecases/signup_usecase.dart';

class SignUpController extends GetxController {
  final SignupUseCase _signupUseCase;

  SignUpController(this._signupUseCase);

  static SignUpController get to => Get.find<SignUpController>();

  Future<void> signUp(String email, String password, {required VoidCallback onSuccess}) async {
    try {
      isLoading = true;
      final params = SignUpParams(email: email, password: password);
      final result = await _signupUseCase.call(params);
      if (result.isSuccess) {
        onSuccess();
      } else {
        Get.snackbar('Error', 'Signup failed');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Signup failed');
    } finally {
      isLoading = false;
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }
}
