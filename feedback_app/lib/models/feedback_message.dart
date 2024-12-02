class FeedbackMessage {
  final String id;
  final String userId;
  final String message;
  final double rating;
  final DateTime createdAt;
  final String hotelId;

  FeedbackMessage({
    required this.id,
    required this.userId,
    required this.message,
    required this.rating,
    required this.createdAt,
    required this.hotelId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'message': message,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
    'hotelId': hotelId,
  };

  factory FeedbackMessage.fromJson(Map<String, dynamic> json) => FeedbackMessage(
    id: json['id'].toString(),
    userId: json['userId'].toString(),
    message: json['message'],
    rating: (json['rating'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt']),
    hotelId: json['hotelId'].toString(),
  );
}

class UserSearchHistory {
  final String id;
  final String userId;
  final String searchQuery;
  final String? searchedUserId;
  final DateTime searchedAt;

  UserSearchHistory({
    required this.id,
    required this.userId,
    required this.searchQuery,
    this.searchedUserId,
    required this.searchedAt,
  });

  factory UserSearchHistory.fromJson(Map<String, dynamic> json) {
    return UserSearchHistory(
      id: json['id'],
      userId: json['user_id'],
      searchQuery: json['search_query'],
      searchedUserId: json['searched_user_id'],
      searchedAt: DateTime.parse(json['searched_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'search_query': searchQuery,
      'searched_user_id': searchedUserId,
      'searched_at': searchedAt.toIso8601String(),
    };
  }
} 