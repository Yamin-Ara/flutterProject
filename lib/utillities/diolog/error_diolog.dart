import 'package:flutter/material.dart';
import 'package:flutter_application_1/utillities/diolog/gen_diolog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'error',
    content: text,
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
