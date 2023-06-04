// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppEventUploadImage extends AppEvent {
  final String filPathUpload;
  AppEventUploadImage({required this.filPathUpload});
}

class AppEventDeleteAccount extends AppEvent {
  AppEventDeleteAccount();
}

class AppEventLogOut extends AppEvent {
  AppEventLogOut();
}

class AppEventInitialize extends AppEvent {
  AppEventInitialize();
}

class AppEventLogIn extends AppEvent {
  final String email;
  final String password;
  AppEventLogIn({required this.email, required this.password});
}

class AppEventGoToRegistration extends AppEvent {
  AppEventGoToRegistration();
}

class AppEventGoToLogIn extends AppEvent {
  AppEventGoToLogIn();
}

class AppEventRegister extends AppEvent {
  final String email;
  final String password;
  AppEventRegister({required this.email, required this.password});
}
