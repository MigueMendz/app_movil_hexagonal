// user_repository.dart
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<bool> loginUser(User user);
}
