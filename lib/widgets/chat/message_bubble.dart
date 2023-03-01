import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this._message, this._username, this._imageURL, this._isMe,
      {Key? key})
      : super(key: key);

  final String _message;
  final String _username;
  final String _imageURL;
  final bool _isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: <Widget>[
      Row(
        mainAxisAlignment:
            _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[400],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: !_isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomRight: _isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
            ),
            width: 150,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            child: Column(
              crossAxisAlignment:
                  _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _message,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  // textAlign: _isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        left: _isMe ? 215 : 140,
        child: CircleAvatar(
          backgroundImage: NetworkImage(_imageURL),
        ),
      ),
    ]);
  }
}
