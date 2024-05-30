import '../domain/usercases/get_user_details_use_case.dart';
import '../domain/usercases/update_user_info_use_case.dart';
import '../domain/usercases/delete_user_account_use_case.dart';

class UserManager {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final UpdateUserInfoUseCase updateUserInfoUseCase;
  final DeleteUserAccountUseCase deleteUserAccountUseCase;

  UserManager({
    required this.getUserDetailsUseCase,
    required this.updateUserInfoUseCase,
    required this.deleteUserAccountUseCase,
  });

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    return await getUserDetailsUseCase.execute(userId);
  }

  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData) async {
    return await updateUserInfoUseCase.execute(userId, newData);
  }

  Future<bool> deleteUserAccount(String userId) async {
    return await deleteUserAccountUseCase.execute(userId);
  }
}
