import 'package:flutter/material.dart';
import '../services/place_service.dart';
import '../services/bookmark_service.dart'; // นำเข้า BookmarkService

class PlaceDetailPage extends StatelessWidget {
  final Place place;
  final String userName; // รับ userName เพื่อเชื่อมโยงข้อมูลผู้ใช้

  PlaceDetailPage({required this.place, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center the image of the place
            Center(
              child: Image.asset(
                place.image,
                height: 250, // Set a fixed height for the image
                fit: BoxFit.cover, // Ensure the image covers its space while maintaining aspect ratio
              ),
            ),
            SizedBox(height: 16.0),
            // Name of the place
            Text(
              place.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Location of the place
            Text(
              place.location,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            // Description of the place
            Text(
              place.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            // Rating and reviews
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 5),
                Text('${place.rating} (${place.reviews} Reviews)', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16.0),
            // Date
            Text('Visited on: ${place.date}', style: TextStyle(fontSize: 14, color: Colors.grey)),
            
            SizedBox(height: 16.0),
            
            // Blue Button to Add to Bookmarks
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // เพิ่มสถานที่ลงใน bookmark โดยใช้ BookmarkService
                  BookmarkService().addBookmark(userName, place);

                  // แสดงข้อความยืนยัน
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to bookmarks!')),
                  );

                  // ปิดหน้า PlaceDetailPage และกลับไปหน้าก่อนหน้า
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // สีฟ้าตามที่คุณต้องการ
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('เพิ่มในบุ๊คมาร์คของคุณ', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
