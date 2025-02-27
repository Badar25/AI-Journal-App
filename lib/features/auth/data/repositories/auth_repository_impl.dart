import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<Result<UserCredential>> login(String email, String password) async {

    final result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return Result.success(result);
    } else {
      return Result.failure('Login failed');
    }
  }

  @override
  Future<Result<UserCredential>> signup(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return Result.success(result);
    } else {
      return Result.failure('Signup failed');
    }
  }
}
