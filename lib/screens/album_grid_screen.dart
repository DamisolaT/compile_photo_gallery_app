// screens/albums_grid_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_gallery_app/model/user_model.dart';
import 'package:photo_gallery_app/services/gallery_service.dart';
import 'package:photo_gallery_app/widgets/album_details_screen';


class AlbumsGridScreen extends StatefulWidget {
  final int userId;
  const AlbumsGridScreen({super.key, required this.userId});

  @override
  State<AlbumsGridScreen> createState() => _AlbumsGridScreenState();
}

class _AlbumsGridScreenState extends State<AlbumsGridScreen> {
  final GalleryService _service = GalleryService();
  late Future<List<Album>> _albums;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _albums = _service.fetchAlbumsByUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search albums...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
            ),

            // Albums Grid
            Expanded(
              child: FutureBuilder<List<Album>>(
                future: _albums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final filteredAlbums = snapshot.data!
                        .where((album) =>
                            album.title.toLowerCase().contains(_searchQuery))
                        .toList();

                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredAlbums.length,
                      itemBuilder: (context, index) {
                        final album = filteredAlbums[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AlbumDetailScreen(albumId: album.id, albumTitle: '',),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'album-${album.id}',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      "https://picsum.photos/id/${album.id + 20}/500/300",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      album.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
