import 'dart:convert';
import 'package:duygucarki/Views/ErrorDialogHelper.dart';
import 'package:duygucarki/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class Requests {
  // Login Fonksiyonu
  Future<void> login(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      Function(bool) _setLoading,
      ) async {
    _setLoading(true); // Yükleme göstergesini başlat

    try {
      final response = await http.post(
        Uri.parse('https://apronmobil.com/Account/Login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserName': usernameController.text,
          'Password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        int id = jsonResponse['id'];
        String userName = jsonResponse['userName'];
        var box = await Hive.openBox('credentials');

        await box.put('Id', id); // Kullanıcı ID'sini kaydet

        // Kullanıcıyı Homepage'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(id: id),
          ),
        );
      } else {
        // Kullanıcı adı veya şifre hatalı ise alert dialog göster
        ErrorDialogHelper.showErrorDialog(context, 'Kullanıcı Adı veya Şifre Hatalı!');
      }
    } catch (e) {
      print('Bir hata oluştu: $e');
      ErrorDialogHelper.showErrorDialog(context, 'Bir hata oluştu: $e');
    } finally {
      _setLoading(false); // Yükleme göstergesini durdur
    }
  }

  // Register Fonksiyonu
  Future<void> postRegister(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      Function(bool) setLoading,
      Function(String) showErrorDialog) async {
    setLoading(true); // Yükleme göstergesini başlat

    try {
      final response = await http.post(
        Uri.parse('https://apronmobil.com/Account/Register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserName': usernameController.text,
          'Password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        showErrorDialog('Kayıt Başarılı');
        passwordController.clear();
        usernameController.clear();
      } else {
        showErrorDialog('Kayıt başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog('Bir hata oluştu: $e');
    } finally {
      setLoading(false); // Yükleme göstergesini durdur
    }
  }

  //Remember Me
  void checkRememberMe(TextEditingController usernameController , TextEditingController passwordController,bool _isChecked) async {
    if (_isChecked == true) {
      // Eşitlik kontrolü
      var box = Hive.box('credentials');
      await box.put('username', usernameController.text);
      await box.put('password', passwordController.text);
    }
  }
}


Future<void> sendSelectedEmotions(int? userId, List<String> selectedEmotions) async {
  //final url = Uri.parse('https://apronmobil.com/Account/AddUserEmotions');
  final url = Uri.parse('http://10.0.2.2:5056/Account/adduseremotions');


  // JSON formatında veri hazırlayın
  final Map<String, dynamic> requestBody = {
    'userId': userId, // userId'yi artık int olarak gönderiyoruz
    'selectedEmotions': selectedEmotions.isNotEmpty ? selectedEmotions : [null, null, null], // Listede boş varsa, null değer gönder
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Veri başarıyla gönderildi.');
    } else {
      print('Hata: ${response.statusCode}');
    }
  } catch (e) {
    print('İstek sırasında hata oluştu: $e');
  }
}

