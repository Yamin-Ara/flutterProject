import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/enums/menu_actions.dart';
import 'package:flutter_application_1/views/nav/emergencyContacts_view.dart';
import 'package:flutter_application_1/views/nav/home_view.dart';
import 'package:flutter_application_1/views/nav/reminder_view.dart';
import 'package:flutter_application_1/views/nav/video_view.dart';

class landingView extends StatefulWidget {
  const landingView({super.key});

  @override
  State<landingView> createState() => _landingViewState();
}

class _landingViewState extends State<landingView> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heathcare App'),
        backgroundColor: const Color.fromARGB(253, 62, 33, 76),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(253, 62, 33, 76),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Reminders',
            backgroundColor: const Color.fromARGB(253, 62, 33, 76),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: 'Videos',
            backgroundColor: const Color.fromARGB(253, 62, 33, 76),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_share_outlined),
            label: 'Emergency',
            backgroundColor: const Color.fromARGB(253, 62, 33, 76),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _pageList.elementAt(_selectedIndex),
    );
  }

//
//

  static const List<Widget> _pageList = <Widget>[
    HomeView(),
    ReminderView(),
    VideoView(),
    EmergencyView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
}
