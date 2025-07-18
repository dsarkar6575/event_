class Post {
  final String id;
  final String content;
  final List<String> image;
  final String place;
  final String? eventDateTime;
  final DateTime createdAt;
  final CreatedBy createdBy;

  Post({
    required this.id,
    required this.content,
    required this.image,
    required this.place,
    required this.createdAt,
    required this.createdBy,
    required this.eventDateTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      content: json['content'],
      image: List<String>.from(json['image'] ?? []),
      place: json['place'],
      eventDateTime: json['time'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: CreatedBy.fromJson(json['createdBy']),
    );
  }
}

class CreatedBy {
  final String id;
  final String username;
  final String email;

  CreatedBy({
    required this.id,
    required this.username,
    required this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
