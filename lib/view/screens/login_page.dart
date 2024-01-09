import 'dart:developer';

import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validate(String val) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

    RegExp emailPattern = RegExp(pattern);

    if (val.isEmpty) {
      return "Enter email...😀";
    } else if (!emailPattern.hasMatch(val)) {
      return "Enter valid email";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chat App",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (val) => validate(val!),
                    decoration: const InputDecoration(
                      labelText: "Enter email",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) => (val == "") ? "Enter  password" : null,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter password",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: const Text("login"),
                    color: Colors.blue,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        User? user = await FirebaseAuthHelper.firebaseAuthHelper
                            .userSigIn(email: email, password: password, context: context);

                        if (user != null) {
                          FireStoreHelper.fireStoreHelper.setUserData(user: user);
                          Navigator.of(context).pushReplacementNamed('home_page', arguments: user);
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      User? user = await FirebaseAuthHelper.firebaseAuthHelper.userGoogleSignIn(context: context);
                      if (user != null) {
                        FireStoreHelper.fireStoreHelper.setUserData(user: user);
                        Navigator.of(context).pushReplacementNamed('home_page');
                      } else {
                        log("$user -----------------");
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text("GOOGLE"),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have accout?"),
            CupertinoButton(
              child: const Text("Sign up"),
              onPressed: () {
                Navigator.of(context).pushNamed('sign_up_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
