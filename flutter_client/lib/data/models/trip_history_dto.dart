class TripHistoryDto {
  final int presenceId;
  final int? driverId;
  final int? tripLogId;
  final DateTime scannedAt;

  TripHistoryDto({
    required this.presenceId,
    required this.driverId,
    required this.tripLogId,
    required this.scannedAt,
  });

  factory TripHistoryDto.fromJson(Map<String, dynamic> json) => TripHistoryDto(
        presenceId: json['presence_id'] as int,
        driverId: json['driver_id'] as int?,
        tripLogId: json['trip_log_id'] as int?,
        scannedAt: DateTime.parse(json['scanned_at'] as String),
      );
}
