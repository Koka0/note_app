import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Map<String, AuthError> authErrorMapping = {
  'user-not-found': const AuthErrorUserNotFound(),
  'weak-password': const AuthErrorWeakPassword(),
  'invalid-email': const AuthErrorInvalidEmail(),
  'email-already-in-use': const AuthErrorEmailAlreadyInUse(),
  'operation-not-allowed': const AuthErrorOperationNotAllowed(),
  'requires-recent-login': const AuthErrorRequiresRecentLogin(),
  'no-current-user': const AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;
  const AuthError({required this.dialogTitle, required this.dialogText});

// implement your base AuthError class
  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

// implement AuthErrorUnknown class
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogText: 'Authentication Error',
          dialogTitle: 'Unknown authentication Error',
        );
}

// implement AuthErrorNoCurrentUser class
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user!',
          dialogText: 'No current user with this information was found!',
        );
}

// auth/requires-recent-login
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogText:
              'You need to log out and log back in again in order to perform this operation',
        );
}

// email-password isn't enable, please make sure you enable it before running the code,
//auth/operation-not-allowed
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: 'Operation not allowed',
          dialogText: 'You cannot register using this method at this moment!',
        );
}

// auth/user not found
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
            dialogTitle: 'User not found',
            dialogText: 'This given user was not found on the server');
}

//auth/weak-password
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
            dialogTitle: 'Weak password',
            dialogText: 'Please chose a strong password or more characters!');
}

//auth/invalid-email
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
            dialogTitle: 'invalid email',
            dialogText:
                'Please make sure you enter valid email and try again!');
}

//auth/email-already-exists
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
            dialogTitle: 'Email already in use',
            dialogText: 'Please choose another email to register with!');
}
