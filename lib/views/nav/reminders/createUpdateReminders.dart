import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notifications/notifications_service.dart';
import 'package:flutter_application_1/utillities/generics/arguements.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/cloud/cloud_reminder.dart';
import '../../../services/cloud/cloud_store.dart';

class createUpdateReminderView extends StatefulWidget {
  const createUpdateReminderView({super.key});

  @override
  State<createUpdateReminderView> createState() =>
      _createUpdateReminderViewState();
}

class _createUpdateReminderViewState extends State<createUpdateReminderView> {
  CloudReminder? _Reminder;
  late final FirebaseCloudStorage _userInfoService;
  late final TextEditingController _textController;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    _userInfoService = FirebaseCloudStorage();
    _textController = TextEditingController();
    notificationServices.initialiseNotifications();
    super.initState();
  }

  void _textControllerListener() async {
    final Reminder = _Reminder;
    if (Reminder == null) {
      return;
    }
    final text = _textController.text;
    await _userInfoService.updateReminder(
      documentId: Reminder.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudReminder> createOrGetExistingNote(BuildContext context) async {
    final widgetReminder = context.getArgument<CloudReminder>();

    if (widgetReminder != null) {
      _Reminder = widgetReminder;
      _textController.text = widgetReminder.text;
      return widgetReminder;
    }

    final existingReminder = _Reminder;
    if (existingReminder != null) {
      return existingReminder;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newReminder =
        await _userInfoService.createNewReminder(ownerUserId: userId);
    _Reminder = newReminder;
    return newReminder;
  }

  void _deleteReminderIfTextIsEmpty() {
    final Reminder = _Reminder;
    if (_textController.text.isEmpty && Reminder != null) {
      _userInfoService.deleteReminder(documentId: Reminder.documentId);
    }
  }

  void _saveReminderIfTextNotEmpty() async {
    final Reminder = _Reminder;
    final text = _textController.text;
    if (Reminder != null && text.isNotEmpty) {
      await _userInfoService.updateReminder(
        documentId: Reminder.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteReminderIfTextIsEmpty();
    _saveReminderIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Reminder"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Medicine Name",
                    ),
                  );
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          IconButton(
            onPressed: () {
              notificationServices.sendNotifications(_textController.text);
            },
            icon: Icon(Icons.access_alarm),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
