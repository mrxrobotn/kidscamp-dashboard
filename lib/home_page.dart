import 'package:flutter/material.dart';
import 'package:kidscamp/components/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Kids Camp',
          backgroundColor: Colors.blue,
          actions: [
            const Icon(Icons.family_restroom),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/parent/auth');
                },
                child: const Text('Parent Dashboard')
            ),
            const SizedBox(width: 15),
          ],
        ),
      body: Container(),
    );
  }
}
