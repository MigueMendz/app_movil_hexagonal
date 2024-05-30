import 'package:flutter/material.dart';
import 'package:proyecto_integrador/user/application/auth_manager.dart';
import 'package:proyecto_integrador/user/domain/usercases/login_user_use_case.dart';
import 'package:proyecto_integrador/user/infraestructure/repositories/api_user_repository.dart';
import 'package:proyecto_integrador/user/presentation/pages/login_page.dart';
import 'package:proyecto_integrador/user/presentation/pages/user_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiUserRepository = ApiUserRepository();
    final loginUserUseCase = LoginUserUseCase(apiUserRepository);
    final authManager = AuthManager(loginUserUseCase);

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(authManager: authManager),
        '/perfil': (context) => UserDetailsPage(),
      },
    );
  }
}