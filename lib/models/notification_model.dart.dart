class NotificationModel {
  final String id;
  final String service;
  final String sector;
  final String message;
  final int notifiedUsers;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.service,
    required this.sector,
    required this.message,
    required this.notifiedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      service: json['service'],
      sector: json['sector'],
      message: json['message'],
      notifiedUsers: json['notifiedUsers'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}