import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Updatedescription extends StatefulWidget {
  const Updatedescription({super.key});

  @override
  State<Updatedescription> createState() => _UpdatedescriptionState();
}

class _UpdatedescriptionState extends State<Updatedescription> {
  final TextEditingController _controller = TextEditingController();

  // API'ye açıklama gönderme fonksiyonu
  Future<void> _saveDescription() async {
    String description = _controller.text.trim();

    if (description.isEmpty) {
      // Boş açıklama uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen geçerli bir açıklama girin.")),
      );
      return;
    }

    // API URL'niz (kendi API'nizi buraya koymalısınız)
    final String apiUrl = 'https://apronmobil.com/Account/UpdateDescription';

    try {
      // JSON formatında gönderilecek veri
      final Map<String, String> requestData = {
        'description': description,
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
          SnackBar(content: Text("Açıklama başarıyla güncellendi.")),
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
        title: Text('Açıklama Düzenleme Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Açıklamayı Buraya Girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDescription,  // Açıklamayı kaydetme fonksiyonu çağrılıyor
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
