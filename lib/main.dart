import 'package:cart_bloc/features/auth/login_or_home_screen.dart';
import 'package:cart_bloc/features/login/ui/login_screen.dart';
import 'package:cart_bloc/theme/dark_theme.dart';
import 'package:cart_bloc/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practise Firebase',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      // darkTheme: darkMode,
      home: const AuthScreen(),
    );
  }
}
