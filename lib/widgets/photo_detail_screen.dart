import 'package:flutter/material.dart';
import 'package:photo_gallery_app/model/photo.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.title)),
      body: Column(
        children: [
          Image.network(photo.url),
          const SizedBox(height: 10),
          Text(photo.title),
        ],
      ),
    );
  }
}
