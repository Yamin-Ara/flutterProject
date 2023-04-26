import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/cloud/cloud_const.dart';
import 'package:flutter_application_1/services/cloud/cloud_exceptions.dart';
import 'package:flutter_application_1/services/cloud/cloud_notes.dart';
import 'package:flutter_application_1/services/cloud/cloud_reminder.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  final Reminder = FirebaseFirestore.instance.collection('reminders');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<void> deleteReminder({required String documentId}) async {
    try {
      await Reminder.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteReminderException();
    }
  }

  Future<void> updateReminder({
    required String documentId,
    required String text,
  }) async {
    try {
      await Reminder.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateReminderException();
    }
  }

  Stream<Iterable<CloudReminder>> allReminders({required String ownerUserId}) {
    final allReminders =
        Reminder.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
            .snapshots()
            .map((event) =>
                event.docs.map((doc) => CloudReminder.fromSnapshot(doc)));
    return allReminders;
  }

  Future<CloudReminder> createNewReminder({required String ownerUserId}) async {
    final document = await Reminder.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedReminder = await document.get();
    return CloudReminder(
      documentId: fetchedReminder.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
