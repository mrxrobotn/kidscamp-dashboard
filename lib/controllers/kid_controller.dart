import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

Future<Map<String, dynamic>> getKidById(String id) async {
  final response = await http.get(Uri.parse('$apiUrl/kids/$id'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load kid');
  }
}

