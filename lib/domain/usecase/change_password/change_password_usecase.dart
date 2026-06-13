import '../../../data/models/change_password_model/change_password_model.dart';
import '../../../data/repositories/change_password/change_password_repository.dart';

class ChangePasswordUsecase {
  final ChangePasswordRepository repository;
  ChangePasswordUsecase(this.repository);

  Future<bool> call({required ChangePasswordModel request}) {
    return repository.changePassword(request: request);
  }
}
