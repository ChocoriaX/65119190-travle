import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  List<dynamic> users = [];

  // Function to load user data from HTTP API
  Future<void> loadUserData() async {
    final url = Uri.parse('http://172.20.10.12:3000/users'); // API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response into a list of users
        users = jsonDecode(response.body); // Get user data from API
        print('User data loaded: ${users.length} users');
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
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

  // Function to reset and reload API data
  Future<void> resetAPI() async {
    // Clear the existing users list
    users.clear();
    print('User data reset. Reloading from API...');
    // Reload the user data from the API
    await loadUserData();
  }
}
