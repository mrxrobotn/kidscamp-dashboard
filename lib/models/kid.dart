import 'package:flutter/material.dart';

class Kid {
  String firstName;
  String lastName;
  String userName;
  String password;
  bool canAccess;
  DateTime? lastLogin;
  List<String> ownedCourses;
  List<String> coursesData;

  Kid({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
    required this.canAccess,
    this.lastLogin,
    required this.ownedCourses,
    required this.coursesData,
  });

  factory Kid.fromJson(Map<String, dynamic> json) {
    return Kid(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      password: json['password'],
      canAccess: json['canAccess'],
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      ownedCourses: List<String>.from(json['ownedCourses']),
      coursesData: List<String>.from(json['coursesData']),
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'password': password,
    'canAccess': canAccess,
    'lastLogin': lastLogin,
    'ownedCourses': ownedCourses,
    'coursesData': coursesData,
  };
}
