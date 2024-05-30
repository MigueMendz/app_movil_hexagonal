import 'package:flutter/material.dart';
import 'package:proyecto_integrador/user/application/auth_manager.dart';
import 'package:proyecto_integrador/user/application/user_manager.dart';
import 'package:proyecto_integrador/user/domain/usercases/delete_user_account_use_case.dart';
import 'package:proyecto_integrador/user/domain/usercases/get_user_details_use_case.dart';
import 'package:proyecto_integrador/user/domain/usercases/login_user_use_case.dart';
import 'package:proyecto_integrador/user/domain/usercases/update_user_info_use_case.dart';
import 'package:proyecto_integrador/user/infraestructure/repositories/api_user_repository.dart';
import 'package:proyecto_integrador/user/infraestructure/services/local_storage_service.dart';
import 'package:proyecto_integrador/user/infraestructure/services/network_service.dart';
import 'package:proyecto_integrador/user/presentation/pages/login_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/user_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inicialización de servicios
    NetworkService networkService = NetworkService();
    LocalStorageService localStorageService = LocalStorageService();
    ApiUserRepository apiUserRepository = ApiUserRepository(
      'http://192.168.56.1:3002', // tu baseUrl
      networkService,
      localStorageService,
    );

    // Monitorear la conexión para sincronizar transacciones pendientes
    networkService.monitorConnection(localStorageService, apiUserRepository);

    // Casos de uso
    final loginUserUseCase = LoginUserUseCase(apiUserRepository);
    final deleteUserAccountUseCase = DeleteUserAccountUseCase(apiUserRepository);
    final updateUserInfoUseCase = UpdateUserInfoUseCase(apiUserRepository);
    final getUserDetailsUseCase = GetUserDetailsUseCase(apiUserRepository);

    // Managers
    final authManager = AuthManager(loginUserUseCase);
    final userManager = UserManager(
      deleteUserAccountUseCase: deleteUserAccountUseCase,
      updateUserInfoUseCase: updateUserInfoUseCase,
      getUserDetailsUseCase: getUserDetailsUseCase,
      localStorageService: localStorageService, // Pasa el servicio al constructor de UserManager
    );

    // Iniciar la aplicación
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(authManager: authManager),
        '/perfil': (context) => UserDetailsPage(userManager: userManager),
      },
    );
  }
}
