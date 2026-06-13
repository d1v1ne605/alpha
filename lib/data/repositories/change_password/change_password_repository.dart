import '../../models/change_password_model/change_password_model.dart';

abstract class ChangePasswordRepository {
  Future<bool> changePassword({required ChangePasswordModel request});
}
