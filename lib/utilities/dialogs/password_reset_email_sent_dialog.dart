import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'Password reset link has been sent to your email. Please check for more info..',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
