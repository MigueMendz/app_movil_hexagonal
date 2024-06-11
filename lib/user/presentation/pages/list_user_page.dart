import 'package:flutter/material.dart';

class ListUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          UserTile(name: 'Migue'),
          UserTile(name: 'Martin'),
          UserTile(name: 'Mendoza'),
          UserTile(name: 'Martin'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '',
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
      title: Container(
        height: 20,
        color: Colors.grey.shade300,
      ),
    );
  }
}
