import 'dart:io';

import 'package:flutter/material.dart';

import '../chat/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isUserLoading, {Key? key})
      : super(key: key);

  final bool isUserLoading;
  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void _userImageHandler(File image) {
    _userImageFile = image;
  }

  void _submitForm() {
    final _formIsValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please pick an image!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_formIsValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail,
        _userPassword,
        _userName,
        _userImageFile,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5.0,
        shadowColor: Colors.orange,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserPickerImage(_userImageHandler),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: const ValueKey('email'),
                    validator: (emailValue) {
                      if (emailValue == null || !emailValue.contains('@')) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(label: Text('Email address:')),
                    onSaved: (value) {
                      _userEmail = value!.trim();
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      key: const ValueKey('username'),
                      validator: (usernameValue) {
                        if (usernameValue == null ||
                            usernameValue.contains(' ') ||
                            usernameValue.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text('Username:')),
                      onSaved: (value) {
                        _userName = value!.trim();
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (passwordValue) {
                      if (passwordValue == null ||
                          passwordValue.isEmpty ||
                          passwordValue.length <= 5) {
                        return 'Please enter min 6 characters password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(label: Text('Password')),
                    onSaved: (value) {
                      _userPassword = value!.trim();
                    },
                  ),
                  const SizedBox(height: 12),
                  if (widget.isUserLoading) const CircularProgressIndicator(),
                  if (!widget.isUserLoading)
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  if (!widget.isUserLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
