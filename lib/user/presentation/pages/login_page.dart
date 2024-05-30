import 'package:flutter/material.dart';
import '../../application/auth_manager.dart';

class LoginPage extends StatelessWidget {
  final AuthManager authManager;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({required this.authManager});

  void login(BuildContext context) async {
    String userEmail = emailController.text;
    String userPassword = passwordController.text;

    bool success = await authManager.loginUser(userEmail, userPassword);
    print('LoginPage success: $success');

    if (success) {
      Navigator.pushNamed(
        context,
        '/perfil',
        arguments: {
          'email': userEmail,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
