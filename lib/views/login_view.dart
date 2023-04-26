import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_exceptions.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/utillities/diolog/error_diolog.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Health App Login'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        titleTextStyle: TextStyle(color: Colors.amber),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    AuthService.firebase()
                        .login(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        landingRoute,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(context, "User not found");
                  } on WrongPasswordAuthException {
                    await showErrorDialog(context, "Wrong Password");
                  } on OtherAuthException {
                    await showErrorDialog(context, "Authentication Error");
                  }

                  // const snackBar =
                  //     SnackBar(content: const Text('Sign up form coming soon'));
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: const Color.fromARGB(238, 46, 59, 65),
              ),
              child: const Text('New User? Register here'),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                final email = _email.text;
                try {
                  await AuthService.firebase().passwordReset(email: email);
                } on UnknownAuthException {
                  await showErrorDialog(
                      context, "Please fill up the email text field");
                }
              },
              label: const Text('Forgot Password'),
              icon: const Icon(
                Icons.assistant,
                color: Colors.amber,
                size: 30.0,
              ),
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
