import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:photo_gallery_app/widgets/album_details_screen';
import 'package:shimmer/shimmer.dart';
import 'package:photo_gallery_app/model/user_model.dart';
import 'package:photo_gallery_app/services/gallery_service.dart';

/// -------------------- Riverpod Provider --------------------
final albumsProvider = FutureProvider.family<List<Album>, int>((
  ref,
  userId,
) async {
  final service = GalleryService();
  return service.fetchAlbums(userId);
});

/// -------------------- AlbumsGridScreen --------------------
class AlbumsGridScreen extends ConsumerStatefulWidget {
  final int userId;
  const AlbumsGridScreen({super.key, required this.userId});

  @override
  ConsumerState<AlbumsGridScreen> createState() => _AlbumsGridScreenState();
}

class _AlbumsGridScreenState extends ConsumerState<AlbumsGridScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final albumsAsyncValue = ref.watch(albumsProvider(widget.userId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // -------------------- Search Bar --------------------
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

            // -------------------- Albums Grid --------------------
            Expanded(
              child: albumsAsyncValue.when(
                data: (albums) {
                  final filteredAlbums = albums
                      .where(
                        (album) =>
                            album.title.toLowerCase().contains(_searchQuery),
                      )
                      .toList();

                  if (filteredAlbums.isEmpty) {
                    return Center(child: Text('No albums found.'));
                  }

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
                              builder: (_) => AlbumDetailScreen(
                                albumId: album.id,
                                albumTitle:
                                    album.title, // 👈 pass album title here
                              ),
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
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://picsum.photos/id/${album.id + 20}/500/300",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            height: 150,
                                            color: Colors.white,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
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
                },
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  ),
                ),
                error: (err, _) => Center(child: Text(err.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
