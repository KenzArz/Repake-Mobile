// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:projectrepake/theme/app_theme.dart';
// import 'package:projectrepake/views/home/home_screen.dart';
import 'package:projectrepake/views/navigation/user_navbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: AppTheme.light(),
        home: UserNavbar());
  }
}
