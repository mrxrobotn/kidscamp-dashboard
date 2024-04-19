import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidscamp/controllers/parent_controller.dart';
import 'package:kidscamp/views/parent/authentication/login_form.dart';

import 'register_form.dart';

enum _Tab { one, two }

class ParentAuthPage extends StatefulWidget {
  const ParentAuthPage({super.key});

  @override
  State<ParentAuthPage> createState() => _ParentAuthPageState();
}

class _ParentAuthPageState extends State<ParentAuthPage> {

  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                CupertinoSegmentedControl<_Tab>(
                  selectedColor: Colors.black,
                  borderColor: Colors.black,
                  pressedColor: Colors.grey,
                  children: const {
                    _Tab.one: Text('Login'),
                    _Tab.two: Text('Register'),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedTab = value;
                    });
                  },
                  groupValue: _selectedTab,
                ),
                const SizedBox(height: 64),
                Builder(
                  builder: (context) {
                    switch (_selectedTab) {
                      case _Tab.one:
                        return const LoginForm();
                      case _Tab.two:
                        return const RegisterForm();
                    }
                  },
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

