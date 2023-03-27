import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Required'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Check email to complete verification",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text(
                'Click here to resend verification code',
                textScaleFactor: 1.5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Go back and log in"),
            )
          ],
        ),
      ),
    );
  }
}
