// main.dart
import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';
import '/widgets/nav_bar.dart';
import '/screens/home_screen.dart';
import '/screens/about_screen.dart';
import '/screens/projects_screen.dart';
import '/screens/education_screen.dart';
import '/screens/contact_screen.dart';
import '/screens/resume_screen.dart';
import '/screens/work_screen.dart';

const Color primaryBlue = Color.fromARGB(255, 43, 89, 241);

void main() => runApp(MyPortfolio());

class MyPortfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manish Portfolio',
      theme: ThemeData(fontFamily: 'Sans'),
      home: SplashScreen(),
    );
  }
}

mixin ResponsivePadding {
  EdgeInsets responsivePadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return EdgeInsets.all(16); // phones
    if (width < 1024) return EdgeInsets.all(24); // tablets
    return EdgeInsets.all(40); // desktops/laptops
  }
}