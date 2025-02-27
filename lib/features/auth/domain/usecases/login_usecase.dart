import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '/common/network/dio_wrapper.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

import '../../../../common/usecase/usecase.dart';

@immutable
class LoginUseCase implements UseCase<UserCredential, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Result<UserCredential>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
