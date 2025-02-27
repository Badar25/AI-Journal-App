import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/network/dio_wrapper.dart';

abstract class AuthRepository {
  /// Firebase login
  Future<Result<UserCredential>> login(String email, String password);

  /// Firebase Signup
  Future<Result<UserCredential>> signup(String email, String password);
}
