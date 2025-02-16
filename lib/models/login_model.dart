// Modelo de Usuario
class UserModel {
  final String email;
  final String password;

  UserModel({required this.email, required this.password});

  // Convertir el objeto a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Crear el objeto desde un mapa (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
    );
  }
}