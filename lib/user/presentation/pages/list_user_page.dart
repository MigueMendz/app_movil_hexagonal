import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/user_data.dart';

class ListUserPage extends StatefulWidget {
  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<User> users = []; // Lista para almacenar los usuarios
  int _currentIndex = 0; // Índice para controlar la selección en la barra de navegación inferior

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Llama a la función para obtener la lista de usuarios al iniciar la página
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://15.0.11.104:3002/list_users')); // Reemplaza 'tu_url_api' por la URL real de tu API

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body);
        setState(() {
          users = usersJson.map((userJson) => User.fromJson(userJson)).toList(); // Convierte los datos JSON en objetos User
        });
      } else {
        throw Exception('Error al obtener la lista de usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener la lista de usuarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga si la lista está vacía
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserTile(name: users[index].name); // Muestra cada usuario en un UserTile
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice de la pestaña actual al seleccionar un ícono en la barra de navegación inferior
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/chat'); // Navega a la segunda página cuando se selecciona el segundo ícono
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
        ],
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String name;

  UserTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(name),
    );
  }
}
