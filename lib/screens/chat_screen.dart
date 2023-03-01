import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> _documentStream = FirebaseFirestore.instance
    //     .collection('chats/NunZiEB24ADuNMq7VdpU/messages')
    //     .snapshots();

    Future<void> _showLogoutDialog() async {
      return showDialog<void>(
        context: context,
        // barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign Out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  }),
            ],
          );
        },
      );
    }

    void initState() {
      super.initState();
      final fbm = FirebaseMessaging.instance;
      fbm.requestPermission();
      FirebaseMessaging.onMessage.listen((message) {
        print(message);
        return;
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print(message);
        return;
      });
      fbm.subscribeToTopic('chat');
    }

    // @override
    // void initState() {
    //   super.initState();

    //   // FOREGROUND ONLY
    //   FirebaseMessaging.onMessage.listen((message) {
    //     print(message);
    //   });

    //   // BACKGROUND ONLY
    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     print(message);
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My chat'),
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: const <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
