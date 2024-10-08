import 'package:flutter/material.dart';
import '../services/place_service.dart'; // Import PlaceService and Place model
import '../services/bookmark_service.dart';
import 'place_detail_page.dart'; // Import PlaceDetailPage for detailed view navigation
import 'profile_page.dart'; // Import ProfilePage
import 'bookmarks_page.dart'; // Import BookmarksPage

class HomePage extends StatefulWidget {
  final String userName;  // ชื่อผู้ใช้ที่ล็อกอิน
  final String email;     // อีเมลของผู้ใช้
  final String profileImage; // พาธรูปโปรไฟล์ผู้ใช้

  HomePage({required this.userName, required this.email, required this.profileImage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // To track the current tab
  late Future<List<Place>> futurePlaces;
  String _searchText = ''; // ตัวแปรสำหรับเก็บค่าการค้นหา

  @override
  void initState() {
    super.initState();
    futurePlaces = PlaceService().loadPlaces(); // Load places from JSON
  }

  // Navigation tabs content
  List<Widget> _widgetOptions() {
    return [
      HomePageContent(
        futurePlaces: futurePlaces, 
        searchText: _searchText, // ส่งค่าการค้นหาไปยัง HomePageContent
        onSearchChanged: _onSearchChanged, // ส่งฟังก์ชันจัดการการเปลี่ยนแปลงค่าค้นหา
        userName: widget.userName, // ส่ง userName ไปยัง HomePageContent
      ), 
      BookmarksPage(userName: widget.userName),  // เพิ่ม userName เพื่อแสดงบุ๊คมาร์คของผู้ใช้
      ProfilePage(userName: widget.userName, email: widget.email, profileImage: widget.profileImage),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ฟังก์ชันจัดการการเปลี่ยนแปลงค่าการค้นหา
  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เที่ยวทั่วไทย',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _widgetOptions().elementAt(_selectedIndex), // Show content based on tab selection
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final Future<List<Place>> futurePlaces;
  final String searchText;
  final Function(String) onSearchChanged;
  final String userName; // เพิ่ม userName เพื่อใช้ในการกรองข้อมูล

  HomePageContent({
    required this.futurePlaces, 
    required this.searchText, 
    required this.onSearchChanged, 
    required this.userName,
  });

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? selectedProvince; // ตัวแปรเก็บค่าจังหวัดที่เลือก
  String searchQuery = ''; // ตัวแปรเก็บค่าการค้นหา

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value; // อัปเดตค่าค้นหาเมื่อผู้ใช้กรอกข้อมูล
              });
              widget.onSearchChanged(value); // เรียกฟังก์ชัน onSearchChanged ที่ได้รับจากพาเรนต์
            },
            decoration: InputDecoration(
              labelText: 'ค้นหาสถานที่หรือจังหวัด...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Dropdown for selecting province
          FutureBuilder<List<Place>>(
            future: widget.futurePlaces,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading places'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No places available'));
              } else {
                final places = snapshot.data!;
                // สร้างรายชื่อจังหวัดที่ไม่มีค่าซ้ำ และเพิ่มตัวเลือก 'ทั้งหมด'
                List<String> provinces = ['ทั้งหมด'] + places.map((place) => place.location).toSet().toList();
                
                return DropdownButton<String>(
                  value: selectedProvince,
                  hint: Text('เลือกจังหวัด'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProvince = newValue;
                    });
                  },
                  items: provinces.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Popular Section Title
          const Text(
            'ยอดนิยม',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Popular Destinations List (ListView)
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: widget.futurePlaces, // Fetch places from JSON
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading places'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No places available'));
                } else {
                  final places = snapshot.data!;

                  // ดึง Bookmark ของผู้ใช้
                  final bookmarks = BookmarkService().getBookmarks(widget.userName);

                  // กรองข้อมูลตามค่าการค้นหาและจังหวัดที่เลือก
                  final filteredPlaces = places.where((place) {
                    final searchLower = searchQuery.toLowerCase();
                    final matchesSearch = place.name.toLowerCase().contains(searchLower) ||
                        place.location.toLowerCase().contains(searchLower);

                    // กรองตามจังหวัดที่เลือก ('ทั้งหมด' จะหมายถึงไม่กรอง)
                    final matchesProvince = selectedProvince == null || selectedProvince == 'ทั้งหมด' || place.location == selectedProvince;

                    return matchesSearch && matchesProvince && !bookmarks.contains(place); // ไม่แสดงสถานที่ที่ถูก Bookmark แล้ว
                  }).toList();

                  if (filteredPlaces.isEmpty) {
                    return Center(child: Text('No places match your search'));
                  }

                  return ListView.builder(
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return _buildPlaceCard(context, place);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build each place card with full-width banner image
  Widget _buildPlaceCard(BuildContext context, Place place) {
    return GestureDetector(
      onTap: () {
        // Navigate to detailed view when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailPage(place: place, userName: widget.userName), // Pass userName to PlaceDetailPage
          ),
        );
      },
      
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width banner image
            Container(
              height: 200, // Set a fixed height for the banner
              width: double.infinity, // Make the image take the full width of the card
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(place.image),
                  fit: BoxFit.cover, // Ensure the image covers the entire container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Place name and location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        place.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 16),
                      const SizedBox(width: 5),
                      Text('${place.rating}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}