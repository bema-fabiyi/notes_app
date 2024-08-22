import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/routes/routing.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: const Color(0xFFE2C084),
          backgroundColor: const Color(0xFFF0F0F0),
        ),
        // inputDecorationTheme: const InputDecorationTheme(
        //   enabledBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.blueGrey),
        //   ),
        //   focusedBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.blueGrey),
        //   ),
        // ),
      ),
      routerConfig: Routing.router,
    );
  }
}
