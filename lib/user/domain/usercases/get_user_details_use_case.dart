import '../repositories/ user_repository.dart';

class GetUserDetailsUseCase {
  final UserRepository userRepository;

  GetUserDetailsUseCase(this.userRepository);

  Future<Map<String, dynamic>> execute(String userId) async {
    return await userRepository.getUserDetails(userId);
  }
}
