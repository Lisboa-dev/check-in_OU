class StudentFormDto {
  final int? id;
  final String university;
  final String route;
  final String schedule;
  final String? qrCodeBase64;

  StudentFormDto({
    this.id,
    required this.university,
    required this.route,
    required this.schedule,
    this.qrCodeBase64,
  });

  factory StudentFormDto.fromJson(Map<String, dynamic> json) {
    return StudentFormDto(
      id: json['id'] as int?,
      university: json['university'] as String,
      route: json['route'] as String,
      schedule: json['schedule'] as String,
      qrCodeBase64: json['qr_code_base64'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'university': university,
        'route': route,
        'schedule': schedule,
      };
}
