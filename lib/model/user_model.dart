// models/user.dart
class User {
  final int id;
  final String name;
  final String username;

  User({required this.id, required this.name, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }
}

// models/album.dart
class Album {
  final int id;
  final String title;
  final int userId;

  Album({required this.id, required this.title, required this.userId});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      userId: json['userId'],
    );
  }
}


