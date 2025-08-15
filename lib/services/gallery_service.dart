import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_gallery_app/model/photo.dart';
import 'package:photo_gallery_app/model/user_model.dart';


class GalleryService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Album>> fetchAlbumsByUser(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/albums?userId=$userId'));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => Album.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchPhotosByAlbum(int albumId) async {
    final res = await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => Photo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
