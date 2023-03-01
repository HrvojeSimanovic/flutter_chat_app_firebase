import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? curAuthUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }
        final chatDocs = streamSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userImageURL'],
            chatDocs[index]['userId'] == curAuthUser!.uid,
            key: ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}
