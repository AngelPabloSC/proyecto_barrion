import 'package:flutter/material.dart';
class UserModel {
  final String name;
  final String email;
  final String password;
  final String sector;
  final String deviceToken;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.sector,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "sector": sector,
      "deviceToken": deviceToken,
    };
  }
}
