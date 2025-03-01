class OutageResponse {
  final String code;
  final String message;
  final OutageData data;

  OutageResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory OutageResponse.fromJson(Map<String, dynamic> json) {
    return OutageResponse(
      code: json['code'],
      message: json['message'],
      data: OutageData.fromJson(json['data']),
    );
  }
}

class OutageData {
  final List<Outage> pastOutages;
  final List<Outage> upcomingOutages;
  final Totals totals;

  OutageData({
    required this.pastOutages,
    required this.upcomingOutages,
    required this.totals,
  });

  factory OutageData.fromJson(Map<String, dynamic> json) {
    return OutageData(
      pastOutages: (json['pastOutages'] as List)
          .map((outage) => Outage.fromJson(outage))
          .toList(),
      upcomingOutages: (json['upcomingOutages'] as List)
          .map((outage) => Outage.fromJson(outage))
          .toList(),
      totals: Totals.fromJson(json['totals']),
    );
  }
}

class Totals {
  final int past;
  final int upcoming;
  final int all;

  Totals({
    required this.past,
    required this.upcoming,
    required this.all,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      past: json['past'],
      upcoming: json['upcoming'],
      all: json['all'],
    );
  }
}

class Outage {
  final String service;
  final String sector;
  final String message;
  final String scheduledDateTime;
  final String createdAt;
  final int usersNotified;
  final String status;

  Outage({
    required this.service,
    required this.sector,
    required this.message,
    required this.scheduledDateTime,
    required this.createdAt,
    required this.usersNotified,
    required this.status,
  });

  factory Outage.fromJson(Map<String, dynamic> json) {
    return Outage(
      service: json['service'],
      sector: json['sector'],
      message: json['message'],
      scheduledDateTime: json['scheduledDateTime'],
      createdAt: json['createdAt'],
      usersNotified: json['usersNotified'],
      status: json['status'],
    );
  }
}