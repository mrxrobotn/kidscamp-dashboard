import 'package:flutter/material.dart';
import 'package:kidscamp/views/parent/authentication/signup_page.dart';
import 'package:kidscamp/views/parent/authentication/singin_page.dart';
import 'package:kidscamp/views/parent/kid_dashboard.dart';
import 'package:kidscamp/views/parent/kids_page.dart';
import 'home_page.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/parent/kids': (context) => const KidsPage(),
  '/parent/kids/dashboard': (context) => const KidDashboard(),
  '/parent/login': (context) => const SignInPage(),
  '/parent/new': (context) => const SignUpPage(),
};
