import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/view/screens/chat_page.dart';
import 'package:chat_app/view/screens/home_page.dart';
import 'package:chat_app/view/screens/login_page.dart';
import 'package:chat_app/view/screens/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ChatApp(),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: (FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser != null) ? 'home_page' : '/',
      routes: {
        '/': (ctx) => LoginPage(),
        'sign_up_page': (ctx) => SignUpPage(),
        'home_page': (ctx) => const HomePage(),
        'chat_page': (ctx) => const ChatPage(),
      },
    );
  }
}
