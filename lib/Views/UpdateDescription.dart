import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Updatedescription extends StatefulWidget {
  const Updatedescription({super.key});

  @override
  State<Updatedescription> createState() => _UpdatelinkState();
}

class _UpdatelinkState extends State<Updatedescription> {
  // TextEditingController, TextField ile yazılan veriyi almak için kullanılır
  final TextEditingController _controller = TextEditingController();

  void _saveLink() {
    String link = _controller.text;

    if (link.isNotEmpty) {
      // Simülasyon: Kaydedilen link'i konsola yazdırma
      print('Kaydedilen Link: $link');

      // İsterseniz bir alert dialog ile kullanıcıya bildirim gösterebilirsiniz
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Açıklama Kaydedildi'),
            content: Text('Girilen Açıklama: $link'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      // Link boş ise kullanıcıyı bilgilendirin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen geçerli bir Açıklama girin')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Açıklama Düzenleme Sayfası'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        // Padding ekleyerek ekranın kenarlarından uzaklaştırdım
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              // TextController'ı bağladım
              keyboardType: TextInputType.url,
              // URL girişi için uygun klavye
              decoration: InputDecoration(
                labelText: 'Açıklamayı Buraya Girin', // Etiket ekledim
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Köşe yuvarlama
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10), // İçerik dolgusu
              ),
            ),
            SizedBox(height: 20), // Buton ile input arasına boşluk ekledim
            ElevatedButton(
              onPressed: _saveLink, // Kaydetme fonksiyonu çağrılıyor
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
