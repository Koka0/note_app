// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/app_bloc.dart';
import 'package:note_app/dialogs/delete_account_dialog.dart';
import 'package:note_app/dialogs/logout_dialog.dart';

enum MenuAction { logout, deleteaccount }

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              context.read<AppBloc>().add(
                    AppEventLogOut(),
                  );
            }
            break;
          case MenuAction.deleteaccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              context.read<AppBloc>().add(
                    AppEventDeleteAccount(),
                  );
            }
          default:
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteaccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
