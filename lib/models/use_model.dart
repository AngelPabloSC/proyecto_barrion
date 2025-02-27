class UserModel {
  final String id;
  final String name;
  final String email;
  final String sector;
  final bool isAdmin;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.sector,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      sector: json['sector'],
      isAdmin: json['isAdmin'],
      createdAt: json['createdAt'],
    );
  }
}