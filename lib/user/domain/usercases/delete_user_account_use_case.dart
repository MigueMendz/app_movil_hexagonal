import '../repositories/ user_repository.dart';

class DeleteUserAccountUseCase {
  final UserRepository userRepository;

  DeleteUserAccountUseCase(this.userRepository);

  Future<bool> execute(String userId) async {
    return await userRepository.deleteUserAccount(userId);
  }
}
