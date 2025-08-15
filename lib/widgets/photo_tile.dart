// widgets/photo_tile.dart


import 'package:flutter/material.dart';
import 'package:photo_gallery_app/model/photo.dart';


class PhotoTile extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;
  
  const PhotoTile({super.key, required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.network(photo.thumbnailUrl, fit: BoxFit.cover),
    );
  }
}
