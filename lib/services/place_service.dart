import 'dart:convert';
import 'package:http/http.dart' as http;

class Place {
  final int id;
  final String name;
  final String location;
  final String description;
  final double rating;
  final int reviews;
  final String image;
  final String date;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.date,
  });

  // Factory constructor to create a Place object from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      image: json['image'],
      date: json['date'],
    );
  }
}

class PlaceService {
  // Load data from HTTP API and parse it
  Future<List<Place>> loadPlaces() async {
    final url = Uri.parse('http://172.20.10.12:3001/places');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // ใช้ utf8.decode เพื่อแปลงข้อมูลที่ได้รับให้เป็น UTF-8
        String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = jsonDecode(jsonString);

        return jsonData.map((item) => Place.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      print('Error loading places: $e');
      return [];
    }
  }
}
