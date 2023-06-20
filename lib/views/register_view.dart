import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:note_app/bloc/app_bloc.dart';
import 'package:note_app/utils/if_debugging.dart';

class RegisterView extends HookWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'nordin.tata0@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'BE16B3FDCD'.ifDebugging);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            keyboardAppearance: Brightness.dark,
            decoration: const InputDecoration(
              hintText: 'Enter your email here...',
            ),
          ),
          TextField(
            controller: passwordController,
            keyboardAppearance: Brightness.dark,
            decoration: const InputDecoration(
              hintText: 'Enter your password here...',
            ),
            obscureText: true,
            obscuringCharacter: '⚫',
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text;
              final password = passwordController.text;
              context.read<AppBloc>().add(
                    AppEventRegister(
                      email: email,
                      password: password,
                    ),
                  );
            },
            child: const Text(
              'Already registered? Login here',
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AppBloc>().add(
                    AppEventGoToLogIn(),
                  );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
