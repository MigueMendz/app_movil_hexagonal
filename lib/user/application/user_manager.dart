import 'package:proyecto_integrador/user/application/usercases/delete_user_account_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/get_user_details_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/list_users_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/update_user_info_use_case.dart';
import 'package:proyecto_integrador/user/infraestructure/services/local_storage_service.dart';

import '../domain/entities/user_entity.dart';

class UserManager {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final UpdateUserInfoUseCase updateUserInfoUseCase;
  final DeleteUserAccountUseCase deleteUserAccountUseCase;
  final ListUsersUseCase listUsersUseCase;

  UserManager({
    required this.getUserDetailsUseCase,
    required this.updateUserInfoUseCase,
    required this.deleteUserAccountUseCase, required LocalStorageService localStorageService,
    required this.listUsersUseCase,
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

  Future<List<User>> listUsers() async {
    return await listUsersUseCase.execute();
  }
}
