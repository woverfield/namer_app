import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("SIGN OUT!"),
        onPressed: () => {FirebaseAuth.instance.signOut()},
      ),
    );
  }
}
