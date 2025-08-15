// screens/user_albums_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_gallery_app/model/user_model.dart';
import 'package:photo_gallery_app/screens/album_grid_screen.dart';
import '../services/gallery_service.dart';


class UserAlbumsScreen extends StatefulWidget {
  const UserAlbumsScreen({super.key});

  @override
  State<UserAlbumsScreen> createState() => _UserAlbumsScreenState();
}

class _UserAlbumsScreenState extends State<UserAlbumsScreen> {
  final GalleryService _service = GalleryService();
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = _service.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Select a User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=${user.id + 10}",
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("@${user.username}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlbumsGridScreen(userId: user.id),
                      ),
                    );
                  },
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
