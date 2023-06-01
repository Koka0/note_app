import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Map<String, AuthError> authErrorMapping = {};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;
  const AuthError({required this.dialogTitle, required this.dialogText});
  //
// implement your base AuthError class
  //
  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

//
// implement AuthErrorUnknown class
//
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogText: 'Authentication Error',
          dialogTitle: 'Unknown authentication Error',
        );
}

//
// implement AuthErrorNoCurrentUser class
//
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user!',
          dialogText: 'No current user with this information was found!',
        );
}
