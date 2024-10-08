import 'package:flutter/material.dart';
import 'package:travle_1/pages/home_page.dart';
import 'package:travle_1/pages/register_page.dart';
import 'package:travle_1/services/auth_service.dart'; // นำเข้า AuthService

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService(); // สร้าง instance ของ AuthService

  @override
  void initState() {
    super.initState();
    _authService.loadUserData(); // โหลดข้อมูลจาก data.json เมื่อเริ่มต้น
  }

  // Function to handle login validation
  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      final String password = _passwordController.text;

      // ใช้ AuthService เพื่อตรวจสอบการ login
      String loginResult = _authService.login(email, password);

      setState(() {
        _isLoading = false;
      });

      if (loginResult == 'Login successful!') {
        // Successful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );

        // ดึงข้อมูลชื่อผู้ใช้และรูปโปรไฟล์จาก AuthService
        final userName = _authService.getUserNameByEmail(email);
        final profileImage = _authService.getProfileImageByEmail(email);

        // ตรวจสอบว่าชื่อผู้ใช้และรูปโปรไฟล์มีค่าหรือไม่
        if (userName == null || userName.isEmpty || profileImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found or invalid data')),
          );
          return; // ถ้าไม่มีข้อมูลผู้ใช้หรือรูปโปรไฟล์ ยกเลิกการดำเนินการ
        }

        // Navigate to the home or dashboard screen after login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: userName,  // ส่งชื่อผู้ใช้ไปที่ HomePage
              email: email,        // ส่งอีเมลไปที่ HomePage
              profileImage: profileImage, // ส่งพาธรูปโปรไฟล์ไปที่ HomePage
            ),
          ),
        );
      } else {
        // Failed login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle
                Text(
                  'เข้าสู่ระบบเพื่อเริ่มต้นการเดินทางท่องเที่ยวที่น่าตื่นเต้น\nพร้อมสำรวจสถานที่ใหม่ ๆ\nและวางแผนการเดินทางของคุณได้เลย!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 30),

                // Social Media Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Facebook login logic
                      },
                      icon: Icon(Icons.facebook, color: Colors.white),
                      label: Text('Facebook', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Google login logic
                      },
                      icon: Icon(Icons.email, color: Colors.white),
                      label: Text('Google', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Form for Email/Phone and Password
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email/Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Icon(Icons.visibility_off),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password logic
                    },
                    child: Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Log In', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to the register page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()), // Replace with your RegisterPage
                        );
                      },
                      child: Text('Sign Up', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
