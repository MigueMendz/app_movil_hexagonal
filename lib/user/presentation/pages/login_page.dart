import 'package:flutter/material.dart';
import 'package:proyecto_integrador/user/presentation/pages/register_page.dart';
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
        '/detail',
        arguments: {
          'email': userEmail,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al iniciar sesión',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Inicia Sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => login(context),
                  child: Text('Iniciar Sesión'),
                ),
                SizedBox(height: 12.0),
                TextButton(
                  onPressed: () => navigateToRegister(context),
                  child: Text('¿No tienes una cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}