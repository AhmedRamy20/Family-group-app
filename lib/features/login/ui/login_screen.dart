import 'package:cart_bloc/components/my_buton.dart';
import 'package:cart_bloc/components/my_text_field.dart';
import 'package:cart_bloc/features/home/ui/home_screen.dart';
import 'package:cart_bloc/features/register/ui/register_screen.dart';
import 'package:cart_bloc/helpers/pass_error_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    // UserCredential userLogin =
    //     FirebaseAuth.instance.signInWithCredential(credential);
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (context.mounted) Navigator.of(context).pop();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FamHome(),
      ));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showErrorMsg(context, e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.person,
                  //   size: 80,
                  //   color: Theme.of(context).colorScheme.inversePrimary,
                  // ),
                  Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(12),
                    //   border: Border.all(color: Colors.black),
                    //   image: DecorationImage(
                    //     image: AssetImage(
                    //       "assets/images/R.png",
                    //     ),
                    //   ),
                    // ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xffF7F7F7),
                        backgroundImage: AssetImage(
                          "assets/images/R.png",
                        ),
                        maxRadius: 80,
                        // child: Image.asset(
                        //   "assets/images/R.png",
                        //   // width: 300,
                        //   // height: 100,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Fam Hall msg",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      hint: "Email",
                      obSecure: false,
                      controller: emailController),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    hint: "Password",
                    obSecure: true,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     const Text("Forget Password"),
                  //   ],
                  // ),
                  Align(
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    text: "Login",
                    onTap: login,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
