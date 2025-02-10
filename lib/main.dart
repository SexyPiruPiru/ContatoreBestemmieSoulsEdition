import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkTheme = true;

  void toggleTheme(bool isDark) {
    setState(() {
      isDarkTheme = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(toggleTheme: () => toggleTheme(!isDarkTheme)),
    );
  }
}