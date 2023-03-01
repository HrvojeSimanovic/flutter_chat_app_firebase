import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  bool _isUserLoading = false;
  late UserCredential? _userCredential;

  void _submitAuthForm(
    String _email,
    String _password,
    String _username,
    File? _image,
    bool isLogin,
  ) async {
    try {
      setState(() {
        _isUserLoading = true;
      });
      if (isLogin && _image == null) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        final User? currentUser = _auth.currentUser;

        final ref =
            _storage.ref().child('user_image').child(currentUser!.uid + '.jpg');
        await ref.putFile(_image!);

        final String _imageURL = await ref.getDownloadURL();

        // if (currentUser != null) {
        await currentUser.updateDisplayName(_username);
        await currentUser.updatePhotoURL(_imageURL);
        await _cloudFirestore.collection('users').doc(currentUser.uid).set({
          'email': _email,
          'username': _username,
          'imageURL': _imageURL,
        });
        // }
      }
      setState(() {
        _isUserLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      String errorMessage = 'An error ocurred. Please check your credentials!';
      if (err.message != null) {
        errorMessage = err.message!;
      }
      final _snackBar = SnackBar(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      setState(() {
        _isUserLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(
        _submitAuthForm,
        _isUserLoading,
      ),
    );
  }
}
