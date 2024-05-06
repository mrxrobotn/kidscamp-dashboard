import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

Future<bool> checkParentByPhone(String phone) async {
  final response = await http.get(Uri.parse('$apiUrl/parents/phone/$phone'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> getParentByPhone(String phone) async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/parents/phone/$phone'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parent');
    }
  } catch (e) {
    throw Exception('Failed to connect to server');
  }
}

Future<void> signUpParent(String phone, String firstName, String lastName, String email, String password, bool canAccess, List<String> kids ) async {

  final response = await http.post(Uri.parse('$apiUrl/parents/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, dynamic>{
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'canAccess': canAccess,
      'kids': kids
    }),
  );

  if (response.statusCode == 200) {
    print('Parent created successfully');
  } else {
    // Handle error
    print('Error posting data: ${response.statusCode}');
    print(response.body);
  }
}

Future<void> loginParent(String phone, String password) async {
  try {
    final response = await http.post(Uri.parse('$apiUrl/parents/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      tokenValue = responseData['token'];
      getLoggedParentId();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('token', tokenValue);
      print('Login successful. Token: $tokenValue');
    } else if (response.statusCode == 404) {
      print('Parent not found');
    } else if (response.statusCode == 401) {
      print('Invalid credentials');
    } else {
      print('Error logging in. Status code: ${response.statusCode}');
    }
  } catch (err) {
    print('Error logging in: $err');
  }
}

Future<String> getLoggedParentId() async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/parents/profile/me'),
      headers: <String, String>{
        'Authorization': 'Bearer $tokenValue',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final user = responseData['user'];
      print('Logged user: $user');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', user['id']);
      // Return the 'id' field from the user object
      return user['id'];
    } else {
      print('Error getting logged parent. Status code: ${response.statusCode}');
      return ''; // Return null if there's an error
    }
  } catch (err) {
    print('Error getting logged parent: $err');
    return ''; // Return null if there's an error
  }
}

Future<List<dynamic>> getkidsByParentId(String parentId) async {
  final response = await http.get(Uri.parse('$apiUrl/parents/$parentId/kids'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return List<String>.from(data['kids']);
  } else {
    throw Exception('Failed to load kids');
  }
}
