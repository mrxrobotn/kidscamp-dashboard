import 'package:flutter/material.dart';
import 'package:kidscamp/views/kid/kid_dashboard.dart';
import 'package:kidscamp/views/parent/kids_page.dart';
import 'home_page.dart';
import 'views/parent/authentication/parent_auth_page.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/parent/auth': (context) => const ParentAuthPage(),
  '/parent/kids': (context) => const KidsPage(),
  '/parent/kids/dashboard': (context) => const KidDashboard(),
};
