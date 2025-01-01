import 'package:flutter/material.dart';

class ErrorDialogHelper {
  // Error mesajını gösteren fonksiyon
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'ı kapat
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
