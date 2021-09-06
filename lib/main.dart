import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/sign_in_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Event';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: title,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SignInScreen(),
    );
  }
}
