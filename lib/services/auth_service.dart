import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AuthService {
  List<dynamic> users = [];

  // Function to load user data from JSON file
  Future<void> loadUserData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString); // แปลง JSON เป็น Map
    users = jsonData['users']; // เข้าถึงข้อมูลผู้ใช้ภายใต้คีย์ 'users'
  }

  // Function to check login credentials
  String login(String email, String password) {
    var user = users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      return 'Login successful!';
    } else {
      return 'Invalid email or password';
    }
  }

  // Function to get user name by email
  String? getUserNameByEmail(String email) {
    var user = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );
    return user != null ? user['name'] as String? : null;
  }

  // Function to get profile image by email
  String? getProfileImageByEmail(String email) {
    var user = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );
    return user != null ? user['profile_image'] as String? : null;
  }
}
