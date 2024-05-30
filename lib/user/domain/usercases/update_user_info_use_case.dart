import '../repositories/ user_repository.dart';

class UpdateUserInfoUseCase {
  final UserRepository userRepository;

  UpdateUserInfoUseCase(this.userRepository);

  Future<bool> execute(String userId, Map<String, dynamic> newData) async {
    return await userRepository.updateUserInfo(userId, newData);
  }
}
