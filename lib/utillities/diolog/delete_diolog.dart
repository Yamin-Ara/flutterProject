import 'package:flutter/material.dart';
import 'package:flutter_application_1/utillities/diolog/gen_diolog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'delete',
    content: 'delete?',
    optionsBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
