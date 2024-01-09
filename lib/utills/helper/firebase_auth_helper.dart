import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email'],);

  Future<User?> userSignUp({required String email, required String password, required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ERROR: ${e.code.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
      print(e.code.toString());
    }

    if (userCredential != null) {
      return userCredential.user;
    }
  }

  Future<User?> userSigIn({required String email, required String password, required BuildContext context}) async {
    UserCredential? userCredential;
    print(email);
    print(password);
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ERROR: ${e.code.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    if (userCredential != null) {
      return userCredential.user;
    }
  }

  Future<User?> userGoogleSignIn({required BuildContext context}) async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    OAuthCredential credential = await GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential? userCredential;

    try {
      userCredential = await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ERROR: ${e.code.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    if (userCredential != null) {
      return userCredential.user;
    }
  }

  Future<void> logOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
