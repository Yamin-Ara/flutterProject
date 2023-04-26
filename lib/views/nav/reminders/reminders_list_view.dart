import 'package:flutter/material.dart';

import '../../../services/cloud/cloud_reminder.dart';
import '../../../utillities/diolog/delete_diolog.dart';

typedef ReminderCallback = void Function(CloudReminder Reminder);

class RemindersListView extends StatelessWidget {
  final Iterable<CloudReminder> reminders;
  final ReminderCallback onDeleteReminder;
  final ReminderCallback onTap;

  const RemindersListView({
    Key? key,
    required this.reminders,
    required this.onDeleteReminder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 800.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders.elementAt(index);
                  return ListTile(
                    onTap: () {
                      onTap(reminder);
                    },
                    title: Text(
                      reminder.text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteReminder(reminder);
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
