import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../services/gallery_service.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  final _service = GalleryService();

  @override
  Future<List<User>> build() async {
    return _service.fetchUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.fetchUsers());
  }
}

final usersProvider =
    AsyncNotifierProvider<UsersNotifier, List<User>>(() => UsersNotifier());
