import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plants',
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

