class StudentForm {
  final int? id;
  final String university;
  final String route;
  final String schedule;
  final String? qrCodeBase64;

  StudentForm({
    this.id,
    required this.university,
    required this.route,
    required this.schedule,
    this.qrCodeBase64,
  });
}
