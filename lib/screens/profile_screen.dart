import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Logged in as: ${user.email}"),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
            child: Text("SIGN OUT!"),
            onPressed: () async => {
              FirebaseAuth.instance.signOut()
              },
          ),
        ),
      ],
    );
  }
}
