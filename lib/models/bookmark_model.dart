class Bookmark {
  String placeId; // รหัสของสถานที่
  String name; // ชื่อของสถานที่
  String location; // ตำแหน่งของสถานที่
  String image; // รูปภาพของสถานที่
  double rating; // คะแนนของสถานที่

  // คอนสตรัคเตอร์สำหรับคลาส Bookmark
  Bookmark({
    required this.placeId, // กำหนดรหัสสถานที่
    required this.name, // กำหนดชื่อสถานที่
    required this.location, // กำหนดตำแหน่งสถานที่
    required this.image, // กำหนดรูปภาพสถานที่
    required this.rating, // กำหนดคะแนนสถานที่
  });

  // แปลง JSON เป็น Bookmark
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      placeId: json['placeId'], // รับค่า placeId จาก JSON
      name: json['name'], // รับค่าชื่อจาก JSON
      location: json['location'], // รับค่าตำแหน่งจาก JSON
      image: json['image'], // รับค่ารูปภาพจาก JSON
      rating: json['rating'], // รับค่าคะแนนจาก JSON
    );
  }

  // แปลง Bookmark เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId, // แปลง placeId เป็น JSON
      'name': name, // แปลงชื่อเป็น JSON
      'location': location, // แปลงตำแหน่งเป็น JSON
      'image': image, // แปลงรูปภาพเป็น JSON
      'rating': rating, // แปลงคะแนนเป็น JSON
    };
  }

  toPlace() {} // ฟังก์ชันเปล่า (สามารถกำหนดการทำงานภายหลัง)
}
