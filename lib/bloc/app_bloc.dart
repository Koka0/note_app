import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:note_app/auth/auth-error.dart';
import '../utils/upload_image.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventLogOut>(appEventLogOut());
    on<AppEventInitialize>(appEventInitialize());
    on<AppEventRegister>(appEventRegister());
    on<AppEventGoToRegistration>(appEventGoToRegistration());
    on<AppEventDeleteAccount>(appEventDeleteAccount());
    on<AppEventUploadImage>(appEventUploadImage());
    on<AppEventLogIn>(appEventLogIn());
    on<AppEventGoToLogIn>(appEventGoToLogIn());
  }
// log out event
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);

  EventHandler<AppEventLogOut, AppState> appEventLogOut() =>
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      };

  // handle the app event initialize
  EventHandler<AppEventInitialize, AppState> appEventInitialize() {
    return (event, emit) async {
      // get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } else {
        final images = await _getImages(user.uid);
        // go grab the user's upload images,
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    };
  }

  EventHandler<AppEventRegister, AppState> appEventRegister() {
    return (event, emit) async {
      // start loading
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        // create the user
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(
          AppStateLoggedIn(
            user: credentials.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(AppStateIsInRegistrationView(
            isLoading: false, authError: AuthError.from(e)));
      }
    };
  }

//handle uploading images
  EventHandler<AppEventUploadImage, AppState> appEventUploadImage() {
    return (event, emit) async {
      final user = state.user;
      //log user out if we don't have an actual user in app state
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // start the loading process
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      // upload the file
      final file = File(event.filPathUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      //after upload is complete, grab the latest file references,
      final images = await _getImages(user.uid);
      // emit the new images and turn off loading,
      emit(
        AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    };
  }

// handle the delete account,
  EventHandler<AppEventDeleteAccount, AppState> appEventDeleteAccount() {
    return (event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log user out if we don't have a current user,
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      // start loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      // Delete the user's folder
      try {
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); // maybe handle the error?
        }
        // delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        //delete the user,
        await user.delete();
        // log user out,
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e)),
        );
      } on FirebaseException {
        // we might not be able to delete the folder,
        // log the user out,
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      }
    };
  }

  EventHandler<AppEventGoToLogIn, AppState> appEventGoToLogIn() {
    return (event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    };
  }

  // handle the app login event,
  EventHandler<AppEventLogIn, AppState> appEventLogIn() {
    return (event, emit) async {
      // log the user in
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;
        // get images from the user
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: userCredential.user!,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    };
  }

// handle the app registration event
  EventHandler<AppEventGoToRegistration, AppState> appEventGoToRegistration() {
    return (event, emit) async {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    };
  }
}
