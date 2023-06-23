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
        centerTitle: true,
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                hintText: 'Enter your email here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(
                      0xff6750a4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                hintText: 'Enter your password here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(
                      0xff6750a4,
                    ),
                  ),
                ),
              ),
              obscureText: true,
              obscuringCharacter: '⚫',
            ),
            const SizedBox(
              height: 10,
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
                'Register',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      AppEventGoToLogIn(),
                    );
              },
              child: const Text('You already have account? Login here '),
            ),
          ],
        ),
      ),
    );
  }
}
