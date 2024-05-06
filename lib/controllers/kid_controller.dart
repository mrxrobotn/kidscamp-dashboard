import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/kid.dart';

class KidController {
  Future<Kid> addKid(Kid kid, String parentId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/kids/parents/$parentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(kid.toJson()),
      );

      if (response.statusCode == 201) {
        return Kid.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create kid');
      }
    } catch (e) {
      throw Exception('Failed to create kid: $e');
    }
  }

  Future<Kid> getKidById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/kids/$id'));

    if (response.statusCode == 200) {
      return Kid.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load kid');
    }
  }
}
