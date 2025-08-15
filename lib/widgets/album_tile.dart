// widgets/album_tile.dart
import 'package:flutter/material.dart';
import 'package:photo_gallery_app/model/user_model.dart';


class AlbumTile extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;
  
  const AlbumTile({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: GridTile(
        child: Container(
          color: Colors.grey[200],
          child: Center(child: Text(album.title, textAlign: TextAlign.center)),
        ),
      ),
    );
  }
}

