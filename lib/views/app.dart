import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/auth-error.dart';
import 'package:note_app/loading/loading_screen.dart';
import 'package:note_app/views/login_view.dart';
import 'package:note_app/views/photo_gallery_view.dart';
import 'package:note_app/views/register_view.dart';
import '../bloc/app_bloc.dart';
import '../dialogs/aut_error_dialog.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()
        ..add(
          AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              iconColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
            color: Color(
              0xff6750a4,
            ),
          ),
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              // this shouldn't happen,
              return Container();
            }
          },
        ),
      ),
    );
  }
}
