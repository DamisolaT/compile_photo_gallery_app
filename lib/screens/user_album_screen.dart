import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_gallery_app/providers/user_notifier.dart';

import 'album_grid_screen.dart';
import 'package:shimmer/shimmer.dart';

class UserAlbumsScreen extends ConsumerStatefulWidget {
  const UserAlbumsScreen({super.key});

  @override
  ConsumerState<UserAlbumsScreen> createState() => _UserAlbumsScreenState();
}

class _UserAlbumsScreenState extends ConsumerState<UserAlbumsScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search user...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => query = value.toLowerCase());
              },
            ),
          ),
          Expanded(
            child: usersState.when(
              data: (users) {
                final filtered = users
                    .where((u) => u.name.toLowerCase().contains(query))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    return ListTile(
                      title: Text(user.name),
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
              },
              loading: () => _buildShimmer(),
              error: (err, _) => _buildError(err.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          leading: const CircleAvatar(),
          title: Container(height: 10, color: Colors.white),
          subtitle: Container(height: 10, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => ref.read(usersProvider.notifier).refresh(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
