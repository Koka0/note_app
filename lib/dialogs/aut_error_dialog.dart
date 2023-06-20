import 'package:flutter/widgets.dart' show BuildContext;
import 'package:note_app/auth/auth-error.dart';
import 'package:note_app/dialogs/generic_dialoge.dart';

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'Ok': false,
    },
  );
}
