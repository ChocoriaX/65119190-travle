import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  final String profileImage; // เพิ่มฟิลด์สำหรับรูปภาพ

  ProfilePage({required this.userName, required this.email, required this.profileImage}); // รับค่า userName, email, และรูปภาพจากผู้ที่ล็อกอิน

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName); // เริ่มต้นด้วยชื่อผู้ที่ล็อกอิน
  }

  // ฟังก์ชันสำหรับการแสดงฟอร์มแก้ไขชื่อ
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
                Navigator.pop(context); // ปิด Popup
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _nameController.text = _editController.text; // แก้ไขชื่อใน TextField
                });
                Navigator.pop(context); // ปิด Popup
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับการ logout
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
                Navigator.pop(context); // ปิด Popup โดยไม่ทำการ Logout
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // ทำการ Logout และนำผู้ใช้กลับไปที่หน้า Login
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
      appBar: AppBar(
      //   // title: Text('Profile'),
      //   // backgroundColor: Colors.purple,
      //   // elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture (Circular)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(widget.profileImage), // ใช้รูปจากพาธที่ได้รับ
              ),
            ),
            SizedBox(height: 20),

            // Display Name Field พร้อมปุ่มแก้ไข
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
                    readOnly: true, // ไม่สามารถแก้ไขได้โดยตรง
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editName, // เรียกฟังก์ชันเพื่อเปิด Popup แก้ไขชื่อ
                ),
              ],
            ),
            SizedBox(height: 15),

            // Email Field (ไม่สามารถแก้ไขได้)
            TextField(
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: TextEditingController(text: widget.email), // อีเมลของผู้ใช้
              readOnly: true, // ไม่ให้แก้ไขอีเมล
            ),
            SizedBox(height: 20),

            Spacer(), // ดันปุ่ม Logout ไปด้านล่าง

            // Logout Button
            ElevatedButton(
              onPressed: _logout, // ฟังก์ชัน logout ที่มีการถามยืนยัน
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
