import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/views/landingView.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/nav/home/createUpdateUserInfo.dart';
import 'package:flutter_application_1/views/nav/home/pedometerView.dart';
import 'package:flutter_application_1/views/nav/home/waterIntakeView.dart';
import 'package:flutter_application_1/views/nav/reminders/createUpdateReminders.dart';
import 'package:flutter_application_1/views/register_view.dart';
import 'package:flutter_application_1/views/verify_view.dart';

void main() async {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const homePage(),
      routes: {
        registerRoute: (context) => const RegistrationView(),
        verifyEmailRoute: (context) => const verifyEmailView(),
        loginRoute: (context) => LoginView(),
        landingRoute: (context) => const landingView(),
        createUpdateUserInfoRoute: (context) =>
            const createUpdateUserInfoView(),
        waterIntakeRoute: (context) => const WaterIntake(),
        showPedometerRoute: (context) => PedometerView(),
        createUpdateRemindersRoute: (context) =>
            const createUpdateReminderView(),
      },
    ),
  );
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const landingView();
                } else {
                  return const verifyEmailView();
                }
              } else {
                return LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
