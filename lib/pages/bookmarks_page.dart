import 'package:flutter/material.dart';
import '../services/place_service.dart';
import '../services/bookmark_service.dart';
import 'place_detail_mark.dart'; // Import PlaceDetailPage สำหรับการนำทางไปยังหน้ารายละเอียด

class BookmarksPage extends StatefulWidget {
  final String userName; // เพิ่ม userName เพื่อเชื่อมโยงกับ bookmarks ของผู้ใช้

  BookmarksPage({required this.userName});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    // ดึง bookmarks สำหรับผู้ใช้คนนี้จาก BookmarkService ที่เชื่อมต่อกับ JSON
    List<Place> bookmarks = BookmarkService().getBookmarks(widget.userName); 

    if (bookmarks.isEmpty) {
      return Center(child: Text('No bookmarks yet.'));
    }

    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final place = bookmarks[index];
        return Card(
          child: ListTile(
            leading: Image.asset(place.image, width: 50, height: 50, fit: BoxFit.cover), // รูปภาพสถานที่จาก JSON
            title: Text(place.name), // ชื่อสถานที่จาก JSON
            subtitle: Text(place.location), // ตำแหน่งจาก JSON
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // ลบ item ออกจาก bookmarks
                setState(() {
                  BookmarkService().removeBookmark(widget.userName, place);
                });

                // แสดงข้อความยืนยันการลบ
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${place.name} has been removed from your bookmarks.')),
                );
              },
            ),
            onTap: () {
              // เมื่อกดที่รายการ นำทางไปยัง PlaceDetailMark
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailMark(
                    place: place,        // ส่งข้อมูลสถานที่ไปยัง PlaceDetailMark จาก JSON
                    userName: widget.userName, // ส่ง userName ไปที่ PlaceDetailMark
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
