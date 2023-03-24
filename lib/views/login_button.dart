import 'package:bloc_advanced/dialogs/generic_dialogs.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDiscrioption,
            optionBuilder: () => {ok: true},
          );
        } else {
          onLoginTapped(email, password);
        }
      },
      child: const Text(login),
    );
  }
}
