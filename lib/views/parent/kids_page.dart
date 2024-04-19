import 'package:flutter/material.dart';

import '../../components/custom_appbar.dart';
import '../../controllers/kid_controller.dart';
import '../../controllers/parent_controller.dart';

class KidsPage extends StatefulWidget {
  const KidsPage({super.key});

  @override
  State<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends State<KidsPage> {
  List<dynamic> kidsIds = [];
  bool isLoading = true;
  String? parentId;

  @override
  void initState() {
    super.initState();
    loadKidsIds();
  }

  Future<void> loadKidsIds() async {
    try {
      parentId = await getLoggedParentId();
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

  @override
  Widget build(BuildContext context) {
    final String phone = ModalRoute.of(context)!.settings.arguments as String;

    if (parentId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your childrens',
        backgroundColor: Colors.blue,
        actions: [
          const Icon(Icons.account_box),
          Text(phone),
          const SizedBox(width: 15),
          const Icon(Icons.logout),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/parent/authentication');
            },
            child: const Text('Logout'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing:
                    10.0, // Spacing between each item horizontally
                mainAxisSpacing: 10.0, // Spacing between each item vertically
              ),
              itemCount: kidsIds.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: [
                      Center(
                        child: Text('Kid ID: ${kidsIds[index]}'),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                          future: getKidById(kidsIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No dates available.');
                            }
                            String firstname = snapshot.data?["firstName"];
                            String lastname = snapshot.data?["lastName"];
                            int? ownedcourses = snapshot.data?["lastName"].toString().length;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(firstname),
                                Text(lastname),
                                Text('Owned Courses:'),
                                Text(ownedcourses.toString()),
                              ],
                            );
                          }
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
