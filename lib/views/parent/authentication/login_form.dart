import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/parent_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> checkExistAndLoginParent(String phone, String password) async {
    setState(() {
      _errorMessage = null;
    });

    final userExists = await checkParentByPhone(phone);
    if (_formKey.currentState!.validate()) {
      Future.delayed(const Duration(seconds: 1), () async {
        if (userExists) {
          print('User exists.');
          loginParent(phone, password).then((value) async {
            // Store user login state
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);
            prefs.setString('phone', phone);

            Navigator.pushNamed(context, '/parent/kids');
          }).catchError((error) {
            setState(() {
              _errorMessage = error.toString();
            });
          });
        } else {
          print('User does not exist.');
          setState(() {
            _errorMessage = 'User does not exist.';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 12.0),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              checkExistAndLoginParent(_phoneController.text, _passwordController.text);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
