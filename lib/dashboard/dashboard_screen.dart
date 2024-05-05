import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard/bodies/category_body.dart';
import 'package:flutter_application_1/dashboard/bodies/home_body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomeBody(),
    );
  }
}
