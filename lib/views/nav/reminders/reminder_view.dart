import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/views/nav/reminders/reminders_list_view.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/cloud/cloud_reminder.dart';
import '../../../services/cloud/cloud_store.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({super.key});

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  late final FirebaseCloudStorage _userInfoService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _userInfoService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Reminders",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(
                Color.fromARGB(253, 62, 33, 76)),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(createUpdateRemindersRoute);
          },
          child: const Icon(Icons.add),
        ),
        StreamBuilder(
          stream: _userInfoService.allReminders(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allReminders = snapshot.data as Iterable<CloudReminder>;
                  return RemindersListView(
                    reminders: allReminders,
                    onDeleteReminder: (Reminder) async {
                      await _userInfoService.deleteReminder(
                          documentId: Reminder.documentId);
                    },
                    onTap: (Reminder) {
                      Navigator.of(context).pushNamed(
                        createUpdateRemindersRoute,
                        arguments: Reminder,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
