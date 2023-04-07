import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_provider.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Auth", () {
    final provider = mockAuthProvider();
    test('Should not be initialsed to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Can not log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<notInitializedException>()),
      );
    });
    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null', () {
      expect(provider.currentUser, null);
    });
    test('Should be initialsed in 2 secs or less', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should take to login', () async {
      final badEmailUser = provider.createUser(
        email: 'abc@meow.com',
        password: 'apple',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = provider.createUser(
        email: 'catto@meow.com',
        password: 'cake',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "misty",
        password: "pika",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logged in should be verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in', () async {
      await provider.logOut();
      await provider.login(
        email: "email",
        password: "pass",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class notInitializedException implements Exception {}

class mockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) {
      throw notInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw notInitializedException();
    }
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) {
      throw notInitializedException();
    }
    if (email == "abc@meow.com") throw UserNotFoundAuthException();
    if (password == "apple") throw WrongPasswordAuthException();
    const user =
        AuthUser(isEmailVerified: false, id: "my_id", email: "bah@g.com,");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> passwordReset({required String email}) {
    if (!isInitialized) {
      throw notInitializedException();
    }
    if (email == "abc@meow.com") throw UserNotFoundAuthException();
    const user =
        AuthUser(isEmailVerified: true, id: "my_id", email: "bah@g.com,");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw notInitializedException();
    }
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(isEmailVerified: true, id: "my_id", email: "bah@g.com,");
    _user = newUser;
  }
}
