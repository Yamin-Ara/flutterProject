import 'package:flutter_application_1/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> passwordReset({
    required String email,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
