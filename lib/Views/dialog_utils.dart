import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String description, {String? url}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: const Text(
                "Vazgeç",
                style: TextStyle(
                  fontFamily: 'Barlow Condensed',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              ),
            ),
            if (url != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print("Ziyaret Et tıklandı: $url");
                  // buraya url launcher da koyabilirsin
                },
                child: const Text(
                  'Ziyaret Et',
                  style: TextStyle(
                    fontFamily: 'Barlow Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),
          ],
        ),
      ],
      title: const Text('Uyarı'),
      contentPadding: const EdgeInsets.all(20),
      content: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Barlow Condensed',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w200,
          fontSize: 18,
        ),
      ),
    ),
  );
}
