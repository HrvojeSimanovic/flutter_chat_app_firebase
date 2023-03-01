import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../screens/splash_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error...try refresh'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ChatAppFlutter',
              theme: ThemeData(
                primarySwatch: Colors.orange,
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue,
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapshot) {
                  // if (userSnapshot.connectionState == ConnectionState.waiting) {
                  //   return const SplachScreen();
                  // }
                  if (userSnapshot.hasData) {
                    return const ChatScreen();
                  }
                  return const AuthScreen();
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
