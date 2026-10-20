import 'package:flutter/material.dart';

import 'screens/gif_search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GIF Search App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF17191F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17191F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MyHomePage(title: 'GIF Search'),
    );
  }
}
