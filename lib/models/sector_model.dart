class Sector {
  final String id;
  final String name;

  Sector({required this.id, required this.name});

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['_id'] ?? '',  // Asegúrate de que el backend envía un campo "_id"
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}