import 'package:proyecto_integrador/user/application/usercases/login_user_use_case.dart';

class AuthManager {
  final LoginUserUseCase loginUserUseCase;

  AuthManager(this.loginUserUseCase);

  Future<bool> loginUser(String email, String password) async {
    bool result = await loginUserUseCase.execute(email, password);
    print('AuthManager result: $result');
    return result;
  }
}