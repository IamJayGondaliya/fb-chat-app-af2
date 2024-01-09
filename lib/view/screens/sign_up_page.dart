import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController CpasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
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
                    validator: (val) => (val == "") ? "Enter email" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter email",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) => (val == "") ? "Enter  password" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter password",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: CpasswordController,
                    validator: (val) => (val == "") ? "Enter conform password" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter conform password",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: Text("Sign up"),
                    color: Colors.blue,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String Cpassword = CpasswordController.text.trim();

                        if (password == Cpassword) {
                          User? user = await FirebaseAuthHelper.firebaseAuthHelper
                              .userSignUp(email: email, password: password, context: context);

                          if (user != null) {
                            Navigator.of(context).pushReplacementNamed('home_page', arguments: user);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password are not matrch"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have account?"),
            CupertinoButton(
              child: Text("Log in"),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }
}
