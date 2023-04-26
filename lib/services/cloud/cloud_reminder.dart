import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/cloud/cloud_const.dart';

@immutable
class CloudReminder {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudReminder({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudReminder.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
