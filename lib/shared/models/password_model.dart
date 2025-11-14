class PasswordModel {
  final String id;
  final String title;
  final String category;
  final String username;
  final String password;
  final String website;
  final String notes;
  final DateTime createdAt;

  PasswordModel({
    required this.id,
    required this.title,
    required this.category,
    required this.username,
    required this.password,
    required this.website,
    required this.notes,
    required this.createdAt,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json, String id) {
    return PasswordModel(
      id: id,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      website: json['website'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
