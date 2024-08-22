import 'package:flutter/material.dart';

void displaydialog(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ));
}
