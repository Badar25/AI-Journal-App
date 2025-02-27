import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '/common/network/dio_wrapper.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

import '../../../../common/usecase/usecase.dart';

@immutable
class SignupUseCase implements UseCase<UserCredential, SignUpParams> {
  final AuthRepository repository;

  const SignupUseCase(this.repository);

  @override
  Future<Result<UserCredential>> call(SignUpParams params) {
    return repository.signup(params.email, params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({required this.email, required this.password});
}
