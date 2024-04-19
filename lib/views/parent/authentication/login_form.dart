import 'package:flutter/material.dart';
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

  Future<void> checkExistAndLoginParent(String phone, String password) async {
    final userExists = await checkParentByPhone(phone);
    if (_formKey.currentState!.validate()) {
      Future.delayed(const Duration(seconds: 1), () async {
        if (userExists) {
          print('User exists.');
          loginParent(phone, password).then((value) => {
            Navigator.pushNamed(context, '/parent/kids', arguments: phone)
          });
        }
        else {
          print('User does not exist.');
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