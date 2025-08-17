import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_gallery_app/model/photo.dart';
import 'package:photo_gallery_app/model/user_model.dart';

class GalleryService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<dynamic>> fetchData(String endpoint, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          throw Exception("Error: ${response.statusCode}");
        }
      } catch (e) {
        attempt++;
        if (attempt >= retries) rethrow;
      }
    }
    throw Exception("Failed after $retries attempts");
  }

  

  Future<List<User>> fetchUsers() async {
    final data = await fetchData("users");
    return data.map<User>((e) => User.fromJson(e)).toList();
  }

  Future<List<Album>> fetchAlbums(int userId) async {
    final data = await fetchData("albums?userId=$userId");
    return data.map<Album>((e) => Album.fromJson(e)).toList();
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    final data = await fetchData("photos?albumId=$albumId");
    return data.map<Photo>((e) => Photo.fromJson(e)).toList();
  }
}
