import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  final String profileImage;
  final String userId; // To be used for updating

  ProfilePage({
    required this.userName,
    required this.email,
    required this.profileImage,
    required this.userId, // userId is received from login
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  // Function to update name through API
  Future<void> _updateName(String newName) async {
    setState(() {
      _isLoading = true;
    });

    // Log the userId to ensure it's correct
    print('User ID: ${widget.userId}');

    final url = 'http://192.168.1.5:3001/users/${widget.userId}'; // Example API URL
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'name': newName}),
      );

      if (response.statusCode == 200) {
        // Successfully updated the name
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ชื่อผู้ใช้ถูกอัปเดตเรียบร้อยแล้ว')),
        );
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error updating name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to show dialog for editing the name
  void _editName() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _editController =
            TextEditingController(text: _nameController.text);
        return AlertDialog(
          title: Text('แก้ไขชื่อ'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              labelText: 'ชื่อบัญชีใหม่',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // Call the update function to update the name
                _updateName(_editController.text);
                setState(() {
                  _nameController.text = _editController.text;
                });
                Navigator.pop(context);
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // Function for logging out
  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture (Circular)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(widget.profileImage),
              ),
            ),
            SizedBox(height: 20),

            // Display Name Field with Edit Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อบัญชี',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true, // Not editable directly
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _isLoading ? null : _editName, // Call the edit function
                ),
              ],
            ),
            SizedBox(height: 15),

            // Email Field (Non-editable)
            TextField(
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: TextEditingController(text: widget.email),
              readOnly: true,
            ),
            SizedBox(height: 20),

            Spacer(),

            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              child: Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
