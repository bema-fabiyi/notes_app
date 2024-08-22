import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/auth.dart';
import 'package:notes_app/pages/home_page.dart';
import 'package:notes_app/pages/login_page.dart';
import 'package:notes_app/pages/sign_up_page.dart';
import 'package:notes_app/routes/app_routes.dart';

class Routing {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.auth, // Use auth route as the initial location
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (ctx, state) {
          return const Auth(); // Use the Auth widget
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (ctx, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (ctx, state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (ctx, state) {
          return const HomePage();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('No route defined for ${state.name}'),
      ),
    ),
  );
}
