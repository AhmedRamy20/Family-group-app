import 'package:cart_bloc/features/home/ui/home_screen.dart';
import 'package:cart_bloc/features/login/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //* so the user is in the loged in state
            return const FamHome();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
