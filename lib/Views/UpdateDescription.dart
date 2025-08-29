import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duygucarki/Views/Requests.dart'; // ✅ BaseUrl için import et

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir açıklama girin.")),
      );
      return;
    }

    // ✅ Base URL Requests sınıfından alınıyor
    final String apiUrl = '${Requests.baseUrl}/Account/UpdateDescription';

    try {
      final Map<String, String> requestData = {
        'DescriptionText': description,
      };

      print("➡️ İstek gönderiliyor...");
      print("URL: $apiUrl");
      print("Headers: {'Content-Type': 'application/json'}");
      print("Body: ${jsonEncode(requestData)}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      print("⬅️ STATUS CODE: ${response.statusCode}");
      print("⬅️ RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Açıklama başarıyla güncellendi.")),
        );

        if (!mounted) return;
        setState(() {
          _controller.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("❌ Hata oluştu: $e");
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
        title: const Text('Açıklama Düzenleme Sayfası'),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDescription,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
