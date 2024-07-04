import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'package:proyecto_integrador/user/application/auth_manager.dart';
import 'package:proyecto_integrador/user/application/user_manager.dart';
import 'package:proyecto_integrador/user/application/usercases/delete_user_account_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/get_user_details_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/login_user_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/list_users_use_case.dart';
import 'package:proyecto_integrador/user/application/usercases/update_user_info_use_case.dart';
import 'package:proyecto_integrador/user/infraestructure/repositories/api_user_repository.dart';
import 'package:proyecto_integrador/user/infraestructure/services/local_storage_service.dart';
import 'package:proyecto_integrador/user/infraestructure/services/network_service.dart';
import 'package:proyecto_integrador/user/presentation/pages/chat_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/list_user_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/login_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/register_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/user_details_page.dart';
import 'firebase_options.dart'; // Importa las opciones generadas

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización de Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializa Firebase
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inicialización de servicios
    NetworkService networkService = NetworkService();
    LocalStorageService localStorageService = LocalStorageService();
    ApiUserRepository apiUserRepository = ApiUserRepository(
      'https://kw2fk5zh-3002.use2.devtunnels.ms', // tu baseUrl
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
    final listUsersUseCase = ListUsersUseCase(apiUserRepository);

    // Managers
    final authManager = AuthManager(loginUserUseCase);
    final userManager = UserManager(
      deleteUserAccountUseCase: deleteUserAccountUseCase,
      updateUserInfoUseCase: updateUserInfoUseCase,
      getUserDetailsUseCase: getUserDetailsUseCase,
      localStorageService: localStorageService,
      listUsersUseCase: listUsersUseCase
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
        '/chat': (context) => ChatPage(),
        '/list': (context) => ListUserPage(),
        '/register': (context) => RegisterPage(),
        "/detail": (context) => UserDetailsPage(userManager: userManager)
      },
    );
  }
}
