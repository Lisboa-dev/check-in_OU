import '../../data/repositories/checkin_repository.dart';
import '../entities/student_form.dart';

class SaveStudentFormUseCase {
  final CheckinRepository repository;

  SaveStudentFormUseCase(this.repository);

  Future<StudentForm> call(StudentForm form) => repository.saveForm(form);
}
