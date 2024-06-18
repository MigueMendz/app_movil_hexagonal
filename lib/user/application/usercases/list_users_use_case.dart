import 'package:proyecto_integrador/user/domain/entities/user_entity.dart';
import '../../domain/repositories/ user_repository.dart';

class ListUsersUseCase {
  final UserRepository _userRepository;

  ListUsersUseCase(this._userRepository);

  Future<List<User>> execute() async {
    try {
      return await _userRepository.listUsers();
    } catch (e) {
      throw Exception('Error al obtener la lista de usuarios: $e');
    }
  }
}
