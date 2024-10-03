import 'place_service.dart';

class BookmarkService {
  static final Map<String, List<Place>> _userBookmarks = {}; // เก็บ Bookmark แยกตามผู้ใช้

  // ฟังก์ชันเพิ่ม Bookmark สำหรับผู้ใช้
  void addBookmark(String userName, Place place) {
    if (_userBookmarks.containsKey(userName)) {
      _userBookmarks[userName]!.add(place); // เพิ่มสถานที่ลงใน Bookmark ของผู้ใช้
    } else {
      _userBookmarks[userName] = [place]; // ถ้ายังไม่มีข้อมูลผู้ใช้ให้สร้างใหม่
    }
  }

  // ฟังก์ชันดึง Bookmark ของผู้ใช้
  List<Place> getBookmarks(String userName) {
    return _userBookmarks[userName] ?? []; // ถ้าไม่มีข้อมูลให้คืนค่าลิสต์ว่าง
  }

  // ฟังก์ชันลบ Bookmark สำหรับผู้ใช้
  void removeBookmark(String userName, Place place) {
    if (_userBookmarks.containsKey(userName)) {
      _userBookmarks[userName]!.remove(place); // ลบสถานที่ออกจาก Bookmark ของผู้ใช้
    }
  }
}