import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/routes/app_routes.dart';
import 'package:notes_app/widgets/custom_button.dart';
import 'package:notes_app/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const route = '/signUp';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool signUpError = false;
  String errorMessage = '';

  void signUp() async {
    showDialog(
      context: context,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      setState(() {
        signUpError = true;
        errorMessage = "Passwords do not match!";
      });
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        createUserDocument(userCredential);

        if (mounted) {
          Navigator.pop(context);
          context.go(AppRoutes.home);
        }
      } on FirebaseAuthException {
        if (mounted) {
          Navigator.pop(context);
        }

        setState(() {
          signUpError = true;
          errorMessage = 'An error occured!';
        });
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'username': usernameController.text,
        'email': emailController.text,
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
                    labelText: 'Username',
                    obscureText: false,
                    controller: usernameController),
                const SizedBox(height: 20),
                CustomTextfield(
                    labelText: 'Email',
                    obscureText: false,
                    controller: emailController),
                const SizedBox(height: 20),
                CustomTextfield(
                    labelText: 'Password',
                    obscureText: true,
                    controller: passwordController),
                const SizedBox(height: 20),
                CustomTextfield(
                    labelText: 'Confirm Password',
                    obscureText: true,
                    controller: confirmPasswordController),
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
                if (signUpError)
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
                  text: 'SignUp',
                  onTap: signUp,
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text(
                    'Already have an account? Login',
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
