import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String body;

  const NotificationDialog({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}