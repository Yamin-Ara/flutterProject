import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/enums/menu_actions.dart';

class landingView extends StatefulWidget {
  const landingView({super.key});

  @override
  State<landingView> createState() => _landingViewState();
}

class _landingViewState extends State<landingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<menuAction>(
            onSelected: (value) async {
              switch (value) {
                case menuAction.logout:
                  final doLogout = await showLogOutDialog(context);

                  if (doLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<menuAction>(
                  value: menuAction.logout,
                  child: Text('logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Text("hello"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out ?'),
        content: const Text('Sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
