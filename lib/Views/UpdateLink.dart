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

  // Backend'e POST isteği gönderecek metot
  Future<void> _saveLink() async {
    String link = _controller.text;

    if (link.isNotEmpty) {
      // URL'nizi buraya yazın
      final url = Uri.parse('http://10.0.2.2:5056/Account/updatelink');  // C# API endpoint

      // POST isteğini gönder
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},  // JSON formatında veri gönderiyoruz
          body: jsonEncode({'link': link}),  // JSON formatında 'link' verisini gönderiyoruz
        );

        if (response.statusCode == 200) {
          // Başarılı ise cevap göster
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Link Kaydedildi'),
                content: Text('Girilen link: $link'),
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
          // Hata durumunda kullanıcıyı bilgilendir
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bir hata oluştu!')),
          );
        }
      } catch (e) {
        // Ağ hatası veya başka bir hata durumunda
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: $e')),
        );
      }
    } else {
      // Link boş ise kullanıcıyı bilgilendir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen geçerli bir link girin')),
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
