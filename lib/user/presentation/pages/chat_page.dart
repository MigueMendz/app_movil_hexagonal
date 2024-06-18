import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  final List<MessageBubble> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late String userEmail;
  int _currentIndex = 0; // Agrega esta línea para controlar la selección en la barra de navegación inferior

  @override
  void initState() {
    super.initState();
    databaseReference.child('messages').onChildAdded.listen((event) {
      setState(() {
        messages.add(MessageBubble(
          sender: event.snapshot.child('sender').value as String,
          text: event.snapshot.child('text').value as String,
          isMe: event.snapshot.child('sender').value as String == 'Daniel', // Reemplaza con lógica real
          timestamp: event.snapshot.child('timestamp').value as String,
          imageUrl: event.snapshot.child('imageUrl').value as String?,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage({String? imageUrl}) {
    final messageText = textController.text;
    if (messageText.isNotEmpty || imageUrl != null) {
      final message = {
        'sender': 'Daniel', // Reemplaza con lógica real
        'text': messageText,
        'timestamp': DateTime.now().toIso8601String(),
        'imageUrl': imageUrl,
      };
      databaseReference.child('messages').push().set(message);
      textController.clear();
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      sendMessage(imageUrl: downloadUrl);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Global'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: Icon(Icons.person),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Escribe...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice de la pestaña actual al seleccionar un ícono en la barra de navegación inferior
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/list'); // Navega a la segunda página cuando se selecciona el segundo ícono
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
        ],
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String timestamp;
  final String? imageUrl;

  MessageBubble({required this.sender, required this.text, required this.isMe, required this.timestamp, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0, // Limita la altura máxima de la imagen
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(imageUrl!, fit: BoxFit.cover),
                ),
              ),
            ),
          if (text.isNotEmpty)
            Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              )
                  : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
