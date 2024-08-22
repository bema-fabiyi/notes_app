import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/routes/app_routes.dart';
import 'package:notes_app/widgets/custom_button.dart';
import 'package:notes_app/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginError = false;
  String errorMessage = '';

  void login() async {
    showDialog(
      context: context,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        context.go(AppRoutes.home);
      }
    } on FirebaseAuthException {
      if (mounted) {
        Navigator.pop(context);
      }

      setState(() {
        loginError = true;
        errorMessage = 'An error occured!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.note_outlined, size: 100),
                const Text(
                  'NOTES APP',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                CustomTextfield(
                    labelText: 'Email',
                    obscureText: false,
                    controller: emailController),
                const SizedBox(height: 20),
                CustomTextfield(
                    labelText: 'Password',
                    obscureText: true,
                    controller: passwordController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                if (loginError)
                  Column(
                    children: [
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                CustomButton(
                  onTap: () {
                    login();
                  },
                  text: 'Login',
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.signUp),
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
