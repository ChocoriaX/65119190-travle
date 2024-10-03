import 'package:flutter/material.dart';
import '../services/place_service.dart'; // Import PlaceService and Place model
import '../services/bookmark_service.dart';
import 'place_detail_page.dart'; // Import PlaceDetailPage for detailed view navigation
import 'profile_page.dart'; // Import ProfilePage
import 'bookmarks_page.dart'; // Import BookmarksPage

class HomePage extends StatefulWidget {
  final String userName;
  final String email;
  final String profileImage;
  final String userId;

  const HomePage({
    required this.userName,
    required this.email,
    required this.profileImage,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // To track the current tab
  late Future<List<Place>> futurePlaces;
  String _searchText = ''; // Variable to store search query

  @override
  void initState() {
    super.initState();
    futurePlaces = PlaceService().loadPlaces(); // Load places from API or JSON
  }

  // Navigation tabs content
  List<Widget> _widgetOptions() {
    return [
      HomePageContent(
        futurePlaces: futurePlaces,
        searchText: _searchText,
        onSearchChanged: _onSearchChanged,
        userName: widget.userName,
        userId: widget.userId, // Pass userId to HomePageContent
      ),
      BookmarksPage(userName: widget.userName), // Pass userName to BookmarksPage
      ProfilePage(
        userName: widget.userName,
        email: widget.email,
        profileImage: widget.profileImage,
        userId: widget.userId, // Pass userId to ProfilePage
      ),
    ];
  }

  // Handle tab navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle search query changes
  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เที่ยวทั่วไทย', style: TextStyle(color: Colors.white)),
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
  final String userName;
  final String userId;

  const HomePageContent({
    Key? key,
    required this.futurePlaces,
    required this.searchText,
    required this.onSearchChanged,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? selectedProvince;
  String searchQuery = '';

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
                searchQuery = value;
              });
              widget.onSearchChanged(value);
            },
            decoration: InputDecoration(
              labelText: 'ค้นหาสถานที่หรือจังหวัด...',
              prefixIcon: const Icon(Icons.search),
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
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading places'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No places available'));
              } else {
                final places = snapshot.data!;
                List<String> provinces = ['ทั้งหมด'] + places.map((place) => place.location).toSet().toList();

                return DropdownButton<String>(
                  value: selectedProvince,
                  hint: const Text('เลือกจังหวัด'),
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

          const Text(
            'ยอดนิยม',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: FutureBuilder<List<Place>>(
              future: widget.futurePlaces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading places'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No places available'));
                } else {
                  final places = snapshot.data!;

                  // ดึง Bookmark ของผู้ใช้
                  final bookmarks = BookmarkService().getBookmarks(widget.userName);

                  final filteredPlaces = places.where((place) {
                    final searchLower = searchQuery.toLowerCase();
                    final matchesSearch = place.name.toLowerCase().contains(searchLower) ||
                        place.location.toLowerCase().contains(searchLower);
                    final matchesProvince = selectedProvince == null || selectedProvince == 'ทั้งหมด' || place.location == selectedProvince;

                    return matchesSearch && matchesProvince && !bookmarks.contains(place);
                  }).toList();

                  if (filteredPlaces.isEmpty) {
                    return const Center(child: Text('No places match your search'));
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

  Widget _buildPlaceCard(BuildContext context, Place place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailPage(
              place: place,
              userName: widget.userName,
              userId: widget.userId,
            ),
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
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(place.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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