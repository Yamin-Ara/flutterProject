import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/register_view.dart';
import 'package:flutter_application_1/views/verify_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const homePage(),
      routes: {
        '/login/': (context) => LoginView(),
        '/register/': (context) => const RegistrationView(),
      },
    ),
  );
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print('email is verified');
                } else {
                  return const verifyEmailView();
                }
              } else {
                return LoginView();
              }
              return const Text('done');
            // if (user?.emailVerified ?? false) {
            //   return const Text('done');
            // } else {
            // return const verifyEmailView();
            // }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
