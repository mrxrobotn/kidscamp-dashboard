import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custom_appbar.dart';
import '../../controllers/kid_controller.dart';
import '../../controllers/parent_controller.dart';
import '../../models/kid.dart';
import '../kid/kid_dashboard.dart';

class KidsPage extends StatefulWidget {
  const KidsPage({super.key});

  @override
  State<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends State<KidsPage> {
  List<dynamic> kidsIds = [];
  bool isLoading = true;
  String? parentId;
  String? phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await checkLoginState();
    if (parentId != null) {
      await loadKidsIds();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadKidsIds() async {
    try {
      final List<dynamic> fetchedKidsIds = await getkidsByParentId(parentId!);
      setState(() {
        kidsIds = fetchedKidsIds;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading kids: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    phone = prefs.getString('phone');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/parent/auth');
    } else {
      parentId = prefs.getString('id');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (parentId == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Your children',
          backgroundColor: Colors.blue,
          actions: [
            const Icon(Icons.account_box),
            Text(phone!),
            const SizedBox(width: 15),
            const Icon(Icons.logout),
            TextButton(
              onPressed: () {
                logout();
              },
              child: const Text('Logout'),
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: const Center(
          child: Text('No kids found for this account.'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your children',
        backgroundColor: Colors.blue,
        actions: [
          const Icon(Icons.account_box),
          Text(phone!),
          const SizedBox(width: 15),
          const Icon(Icons.logout),
          TextButton(
            onPressed: () {
              logout();
            },
            child: const Text('Logout'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: kidsIds.length + 1, // Add 1 for the add kid button
        itemBuilder: (BuildContext context, int index) {
          if (index == kidsIds.length) {
            return GestureDetector(
              onTap: () {
                _showMyDialog(context);
              },
              child: const Card(
                child: Center(
                  child: Icon(Icons.add, size: 50),
                ),
              )
            );
          }
          return GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('kidId', kidsIds[index]);
              Navigator.pushNamed(context, '/parent/kids/dashboard');
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Kid ID: ${kidsIds[index]}'),
                  FutureBuilder<Kid>(
                    future: KidController().getKidById(kidsIds[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('No data available.');
                      }
                      String firstname = snapshot.data!.firstName;
                      String lastname = snapshot.data!.lastName;
                      List<String>? ownedCourses = snapshot.data!.ownedCourses;
                      int ownedCoursesLength = ownedCourses!.length;

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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('id');
    Navigator.pushReplacementNamed(context, '/parent/auth');
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new kid:'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Firstname'),
                    controller: firstName,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Lastname'),
                    controller: lastName,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    controller: userName,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: password,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                Kid kid = Kid(
                    firstName: firstName.text,
                    lastName: lastName.text,
                    userName: userName.text,
                    password: password.text,
                    canAccess: false,
                    ownedCourses: [],
                    coursesData: []
                );
                KidController().addKid(kid, parentId!);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                // You can add form validation here
                // For simplicity, I'm just popping the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}