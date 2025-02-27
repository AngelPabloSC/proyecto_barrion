class NotificationModel {
  final String service;
  final String sector;
  final String message;

  NotificationModel({
    required this.service,
    required this.sector,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'sector': sector,
      'message': message,
    };
  }
}