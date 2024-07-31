import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namer_app/main.dart';
import 'package:namer_app/screens/welcome_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return MyHomePage();
            } else { // user is not logged in
              return WelcomeScreen();
            }
          }),
    );
  }
}
