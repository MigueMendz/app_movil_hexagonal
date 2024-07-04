import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with WidgetsBindingObserver {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPendingRegistrations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkPendingRegistrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pendingData = prefs.getString('pendingRegistration');
    if (pendingData != null) {
      await _register(pendingData);
    }
  }

  Future<void> register(BuildContext context) async {
    String userName = nameController.text;
    String userEmail = emailController.text;
    String userPassword = passwordController.text;

    if (userName.isEmpty || userEmail.isEmpty || userPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, complete todos los campos.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    final userData = jsonEncode({
      'name': userName,
      'email': userEmail,
      'password': userPassword,
    });

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pendingRegistration', userData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sin conexión a internet. Registro guardado temporalmente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });

      await _register(userData);
    }
  }

  Future<void> _register(String userData) async {
    final response = await http.post(
      Uri.parse('https://kw2fk5zh-3002.use2.devtunnels.ms/create_user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: userData,
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registro exitoso. Ahora puede iniciar sesión.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('pendingRegistration');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al registrar usuario',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkPendingRegistrations();
    }
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      _checkConnectivityAndReload();
    }
  }

  Future<void> _checkConnectivityAndReload() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _checkPendingRegistrations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
                    'Regístrate',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 12.0),
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
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () => register(context),
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
