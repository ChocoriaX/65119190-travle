import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // URL ของ API ที่ใช้สำหรับการลงทะเบียน
  final String apiUrl = 'http://172.20.10.12:3000/users';
  List<dynamic> users = []; // List to store users

  // ฟังก์ชันสำหรับการลงทะเบียนผู้ใช้ใหม่
  Future<String> register(String name, String email, String password, String profileImage) async {
    final url = Uri.parse(apiUrl);

    // ข้อมูลผู้ใช้ที่ต้องการส่งไปยัง API
    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password,
      "profile_image": profileImage,
    };

    try {
      // ส่งข้อมูลไปยัง API ด้วย HTTP POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData), // แปลงข้อมูลเป็น JSON
      );

      if (response.statusCode == 201) {
        // การลงทะเบียนสำเร็จ
        return 'Registration successful!';
      } else {
        // การลงทะเบียนล้มเหลว
        return 'Failed to register. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error during registration: $e');
      return 'Error during registration.';
    }
  }

  // ฟังก์ชันสำหรับการโหลดข้อมูลผู้ใช้ทั้งหมด
  Future<void> loadUserData() async {
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // แปลง JSON เป็น List ของผู้ใช้
        users = jsonDecode(response.body);
        print('User data loaded: ${users.length} users');
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // ฟังก์ชันสำหรับการรีเซ็ตข้อมูลผู้ใช้ (Reset and reload user data)
  Future<void> resetAPI() async {
    // Clear the users list
    users.clear();
    print('User data reset.');

    // Optionally reload the data from the API
    await loadUserData();
  }
}
