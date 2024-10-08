import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  // Load JSON from assets and parse it
  Future<List<Place>> loadPlaces() async {
    final String jsonString = await rootBundle.loadString('assets/places.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString); // แปลงเป็น Map เพื่อเข้าถึงคีย์ 'places'
    final List<dynamic> placesData = jsonData['places']; // เข้าถึงรายการของสถานที่ภายใต้คีย์ 'places'

    // แปลงแต่ละรายการของ 'places' เป็น Place object
    return placesData.map((item) => Place.fromJson(item)).toList();
  }
}
