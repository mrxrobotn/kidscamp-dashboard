import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/kid_controller.dart';
import '../../models/kid.dart';

class KidDashboard extends StatefulWidget {
  const KidDashboard({super.key});

  @override
  State<KidDashboard> createState() => _KidDashboardState();
}

class _KidDashboardState extends State<KidDashboard> {
  Future<String?> _getKidId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('kidId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kid Dashboard:'),
      ),
      body: FutureBuilder<Kid?>(
        future: _getKid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          }

          Kid kid = snapshot.data!;
          String firstname = kid.firstName;
          String lastname = kid.lastName;
          List<String>? ownedCourses = kid.ownedCourses;
          int ownedCoursesLength = ownedCourses?.length ?? 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(firstname),
              Text(lastname),
              const Text('Owned Courses:'),
              Text(ownedCoursesLength.toString()),
            ],
          );
        },
      ),
    );
  }

  Future<Kid?> _getKid() async {
    String? kidId = await _getKidId();
    if (kidId != null) {
      return KidController().getKidById(kidId);
    }
    return null;
  }
}
