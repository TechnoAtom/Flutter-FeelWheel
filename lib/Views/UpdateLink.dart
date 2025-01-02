import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Updatelink extends StatefulWidget {
  const Updatelink({super.key});

  @override
  State<Updatelink> createState() => _UpdatelinkState();
}

class _UpdatelinkState extends State<Updatelink> {
  final TextEditingController _controller = TextEditingController();

  // API'ye link gönderme fonksiyonu
  Future<void> _saveLink() async {
    String link = _controller.text.trim();

    if (link.isEmpty) {
      // Boş link uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen geçerli bir link girin.")),
      );
      return;
    }

    // API URL'niz
    final String apiUrl = 'https://apronmobil.com/Account/UpdateLink';

    try {
      // JSON formatında gönderilecek veri
      final Map<String, String> requestData = {
        'LinkUrl': link,
      };

      // POST isteği yapma
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Başarılı cevap durumunda
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Link başarıyla güncellendi.")),
        );

        // TextField'ı boşalt
        setState(() {
          _controller.clear();
        });
      } else {
        // Başarısız cevap durumunda
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Güncellenmek üzere bir hata oluştu.")),
        );
      }
    } catch (e) {
      // Hata durumunda
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Link Düzenleme Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.url,  // URL girişi için uygun klavye
              decoration: InputDecoration(
                labelText: 'Linki Buraya Girin',  // Etiket
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),  // Köşe yuvarlama
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),  // İçerik dolgusu
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLink,  // Kaydetme fonksiyonu çağrılıyor
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
