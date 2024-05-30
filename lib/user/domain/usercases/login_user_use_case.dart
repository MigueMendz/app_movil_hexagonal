import 'package:proyecto_integrador/user/domain/entities/user_entity.dart';

import '../repositories/ user_repository.dart';

class LoginUserUseCase {
  final UserRepository userRepository;

  LoginUserUseCase(this.userRepository);

  Future<bool> execute(String email, String password) async {
    User user = User(email: email, password: password);
    bool result = await userRepository.loginUser(user);
    print('LoginUserUseCase result: $result');
    return result;
  }
}
