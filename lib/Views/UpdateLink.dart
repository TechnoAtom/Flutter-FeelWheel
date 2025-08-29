import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duygucarki/Views/Requests.dart'; // ✅ BaseUrl import edildi

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir link girin.")),
      );
      return;
    }

    // ✅ Requests.baseUrl kullanıldı
    final String apiUrl = '${Requests.baseUrl}/Account/UpdateLink';

    try {
      final Map<String, String> requestData = {
        'LinkUrl': link,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Link başarıyla güncellendi.")),
        );
        if (!mounted) return; // ✅ widget dispose edilmişse hata önle
        setState(() {
          _controller.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: ${response.statusCode}")),
        );
      }
    } catch (e) {
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
        title: const Text('Link Düzenleme Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Linki Buraya Girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLink,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
