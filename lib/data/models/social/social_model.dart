class UserRankModel {
  final String id;
  final String name;
  final String email;
  final int totalPoints;
  final int rank;
  final String? photoUrl;

  UserRankModel({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.rank,
    this.photoUrl,
  });

  factory UserRankModel.fromMap(Map<String, dynamic> map, String id, int rank) {
    return UserRankModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      totalPoints: map['totalPoints'] ?? 0,
      rank: rank,
      photoUrl: map['photoUrl'],
    );
  }
}

class FriendModel {
  final String id;
  final String name;
  final String email;
  final int totalPoints;
  final String? photoUrl;
  final DateTime addedAt;

  FriendModel({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    this.photoUrl,
    required this.addedAt,
  });
}