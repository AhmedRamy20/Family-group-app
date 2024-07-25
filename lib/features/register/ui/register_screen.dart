import 'dart:io';

import 'package:cart_bloc/components/my_buton.dart';
import 'package:cart_bloc/components/my_text_field.dart';
import 'package:cart_bloc/features/home/ui/home_screen.dart';
import 'package:cart_bloc/features/login/ui/login_screen.dart';
import 'package:cart_bloc/helpers/pass_error_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  File? _pickedImage;

  final ImagePicker _imagePicker = ImagePicker();

  void pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  void register() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (confirmPassController.text != passwordController.text) {
      Navigator.of(context).pop();

      showErrorMsg(context, "The Password doesn't match!!");
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        //* Upload image to Firebase Storage
        String? imageUrl;
        if (_pickedImage != null) {
          imageUrl = await uploadImageToStorage(_pickedImage!);
        }

        //* Create user Document and store its info (Credential) in firestore database
        await createUserDocument(userCredential, imageUrl);
        if (context.mounted) Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FamHome(),
        ));
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        showErrorMsg(context, e.code);
      }
    }
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      showErrorMsg(context, 'Failed to upload image');
      return null;
    }
  }

  Future<void> createUserDocument(
      UserCredential? userCredential, String? imageUrl) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'userName': userNameController.text,
        'imageUrl': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
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

                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                      child: _pickedImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Fam Hall msg"),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      hint: "user name",
                      obSecure: false,
                      controller: userNameController),
                  const SizedBox(
                    height: 20,
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
                    height: 20,
                  ),
                  MyTextField(
                    hint: "Confirm Password",
                    obSecure: true,
                    controller: confirmPassController,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    text: "Register",
                    onTap: register,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
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
