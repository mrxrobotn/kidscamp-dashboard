import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';

import 'register_form.dart';

enum AuthTab { login, register }

class ParentAuthPage extends StatefulWidget {
  const ParentAuthPage({Key? key}) : super(key: key);

  @override
  State<ParentAuthPage> createState() => _ParentAuthPageState();
}

class _ParentAuthPageState extends State<ParentAuthPage> {
  AuthTab _selectedTab = AuthTab.login;

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
                CupertinoSegmentedControl<AuthTab>(
                  selectedColor: Colors.black,
                  borderColor: Colors.black,
                  pressedColor: Colors.grey,
                  children: const {
                    AuthTab.login: Text('Login'),
                    AuthTab.register: Text('Register'),
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
                      case AuthTab.login:
                        return const LoginForm();
                      case AuthTab.register:
                        return const RegisterForm();
                      default:
                        return Container(); // Default case
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
