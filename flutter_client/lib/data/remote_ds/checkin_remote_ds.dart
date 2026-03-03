import 'package:dio/dio.dart';

import '../models/student_form_dto.dart';
import '../models/trip_history_dto.dart';

class CheckinRemoteDataSource {
  final Dio dio;

  CheckinRemoteDataSource(this.dio);

  Future<String> login(String email, String password) async {
    final response = await dio.post(
      '/auth/token',
      data: {'username': email, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return response.data['access_token'] as String;
  }

  Future<StudentFormDto> upsertForm(StudentFormDto dto) async {
    final response = await dio.post('/formulario', data: dto.toJson());
    return StudentFormDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getQr() async {
    final response = await dio.get('/formulario/qrcode');
    return response.data as Map<String, dynamic>;
  }

  Future<List<TripHistoryDto>> getMyHistory() async {
    final response = await dio.get('/alunos/historico');
    return (response.data as List)
        .map((e) => TripHistoryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> scanStudent({required int studentId, required String qrPayload}) async {
    await dio.post('/scan/$studentId', data: {'qr_payload': qrPayload});
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await dio.get('/admin/dashboard');
    return response.data as Map<String, dynamic>;
  }
}
