import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String _enteredMessage = '';
  final _myController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': currentUser!.uid,
      'username': userData['username'],
      'userImageURL': userData['imageURL'],
    });
    _myController.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Message',
              ),
              onChanged: (inputValue) {
                setState(() {
                  _enteredMessage = inputValue;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              color: _enteredMessage.trim().isEmpty
                  ? null
                  : Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
