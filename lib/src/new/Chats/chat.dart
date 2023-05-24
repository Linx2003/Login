import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../UserData.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedMessageIndex = -1;
  final ScrollController _scrollController = ScrollController();
  bool _isButtonDisabled = true;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: getMessagesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error al cargar los mensajes');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      final text = message['text'];
                      final userName = message['usuario'];
                      final timestamp = message['timestamp'] as Timestamp;
                      final formattedTimestamp = DateFormat('d MMM, HH:mm').format(timestamp.toDate());
                      final isUserMessage = (userName == UserData.userName);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMessageIndex = -1;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            _selectedMessageIndex = index;
                          });
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Align(
                                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Text(
                                    userName ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                  isUserMessage ? 16 : 8,
                                  0,
                                  isUserMessage ? 8 : 16,
                                  8,
                                ),
                                child: Column(
                                  crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      text,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      formattedTimestamp,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _selectedMessageIndex == index
                                  ? IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        final messageId = messages[index].id;
                                        onDeleteMessage(messageId);
                                        setState(() {
                                          _selectedMessageIndex = -1;
                                        });
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      setState(() {
                        _isButtonDisabled = text.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          final message = _messageController.text;
                          final userName = UserData.userName ?? '';
                          saveMessage(message, userName);
                          _messageController.clear();
                          setState(() {
                            _isButtonDisabled = true;
                          });
                        },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getMessagesStream() {
    final CollectionReference messagesRef =
        FirebaseFirestore.instance.collection('messages');

    return messagesRef.orderBy('timestamp').snapshots();
  }

  Future<void> saveMessage(String message, String userName) async {
    try {
      final CollectionReference messagesRef =
          FirebaseFirestore.instance.collection('messages');

      await messagesRef.add({
        'text': message,
        'timestamp': DateTime.now(),
        'usuario': userName,
      });
    } catch (e) {
      print('Error al guardar el mensaje: $e');
    }
  }

  Future<void> onDeleteMessage(String messageId) async {
    try {
      final CollectionReference messagesRef =
          FirebaseFirestore.instance.collection('messages');

      await messagesRef.doc(messageId).delete();
    } catch (e) {
      print('Error al borrar el mensaje: $e');
    }
  }
}
