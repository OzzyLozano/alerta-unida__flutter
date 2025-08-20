class Checkin {
  final int alertId;
  final String name;
  final String email;
  final int? meetingPoint;
  final String areYouOkay;

  Checkin({
    required this.alertId,
    required this.name,
    required this.email,
    this.meetingPoint,
    required this.areYouOkay,
  });

  Map<String, dynamic> toJson() {
    return {
      "alert_id": alertId,
      "name": name,
      "email": email,
      "meeting_point": meetingPoint,
      "are_you_okay": areYouOkay,
    };
  }

  factory Checkin.fromJson(Map<String, dynamic> json) {
    return Checkin(
      alertId: json['alert_id'],
      name: json['name'],
      email: json['email'],
      meetingPoint: json['meeting_point'],
      areYouOkay: json['are_you_okay'],
    );
  }
}
