import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../application/user_manager.dart';

class UserDetailsPage extends StatefulWidget {
  final UserManager userManager;

  UserDetailsPage({required this.userManager});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showSnackBar(String message, {Color backgroundColor = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userEmail = userData['email'];

    return FutureBuilder<Map<String, dynamic>>(
      future: widget.userManager.getUserDetails(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error al cargar los detalles del usuario'),
            ),
          );
        } else {
          final userData = snapshot.data!;
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          passwordController.text = userData['password'] ?? '';

          return Scaffold(
            appBar: AppBar(
              title: Text('Detalles del Usuario'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300], // Color del círculo central
                        ),
                        child: Icon(
                          Icons.person, // Icono para representar la imagen de perfil
                          size: 80,
                          color: Colors.grey[600], // Color del icono
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Nombre:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Nombre',
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Correo Electrónico:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Correo Electrónico',
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Contraseña:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String newName = nameController.text;
                            String newEmail = emailController.text;
                            String newPassword = passwordController.text;

                            bool success = await widget.userManager.updateUserInfo(
                              userEmail,
                              {'name': newName, 'email': newEmail, 'password': newPassword},
                            );
                            if (success) {
                              _showSnackBar('Los cambios se guardaron correctamente.');
                            } else {
                              _showSnackBar('Hubo un problema al guardar los cambios.', backgroundColor: Colors.red);
                            }
                          },
                          child: Text('Guardar Cambios'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool success = await widget.userManager.deleteUserAccount(userEmail);
                            if (success) {
                              _showSnackBar('La cuenta se eliminó correctamente.');
                              Navigator.pushReplacementNamed(context, '/'); // Cambia '/' por la ruta correcta
                            } else {
                              _showSnackBar('Hubo un problema al eliminar la cuenta.', backgroundColor: Colors.red);
                            }
                          },
                          child: Text('Eliminar Cuenta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
