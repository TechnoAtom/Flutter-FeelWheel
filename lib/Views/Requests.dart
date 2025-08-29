import 'package:dio/dio.dart';
import 'package:duygucarki/Views/ErrorDialogHelper.dart';
import 'package:duygucarki/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Requests {
  // 🌍 Base URL'ler
  static const String prodUrl = 'https://feelwheel.web.tr';
  static const String localUrl = "http://10.0.2.2:5268";

  // 🔀 Ortam seçici (true -> local, false -> prod)
  static const bool useLocal = false;

  static String get baseUrl => useLocal ? localUrl : prodUrl;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ),
  );

  // 🔑 Login
  Future<void> login(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      Function(bool) _setLoading,
      ) async {
    _setLoading(true);
    try {
      final bodyData = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      print("➡️ LOGIN isteği atılıyor...");
      print("Body: $bodyData");

      final response = await _dio.post('/Account/Login', data: bodyData);

      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ RESPONSE BODY: ${response.data}");

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        int id = jsonResponse['id'];
        String userName = jsonResponse['userName'];

        print("✅ Login Başarılı - ID: $id, userName: $userName");

        var box = await Hive.openBox('credentials');
        await box.put('Id', id);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage(id: id)),
        );
      } else {
        ErrorDialogHelper.showErrorDialog(
            context, 'Kullanıcı Adı veya Şifre Hatalı!');
      }
    } catch (e) {
      print('❌ Bir hata oluştu (LOGIN): $e');
      ErrorDialogHelper.showErrorDialog(context, 'Bir hata oluştu: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 📝 Register
  Future<void> postRegister(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      Function(bool) setLoading,
      Function(String) showErrorDialog,
      ) async {
    setLoading(true);
    try {
      final bodyData = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      print("➡️ REGISTER isteği atılıyor...");
      print("Body: $bodyData");

      final response = await _dio.post('/Account/Register', data: bodyData);

      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ RESPONSE BODY: ${response.data}");

      if (response.statusCode == 200) {
        showErrorDialog('Kayıt Başarılı');
        usernameController.clear();
        passwordController.clear();
      } else {
        showErrorDialog('Kayıt başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Bir hata oluştu (REGISTER): $e');
      showErrorDialog('Bir hata oluştu: $e');
    } finally {
      setLoading(false);
    }
  }

  // 💾 Remember Me
  void checkRememberMe(TextEditingController usernameController,
      TextEditingController passwordController, bool _isChecked) async {
    if (_isChecked) {
      var box = Hive.box('credentials');
      await box.put('username', usernameController.text);
      await box.put('password', passwordController.text);
      print("💾 RememberMe kaydedildi: "
          "username=${usernameController.text}, password=${passwordController.text}");
    }
  }

  // 📌 Emotions
  Future<void> sendSelectedEmotions(
      int? userId, List<String> selectedEmotions) async {
    final requestBody = {
      if (userId != null) 'UserId': userId,
      'SelectedEmotions': selectedEmotions,
    };
    try {
      print("➡️ EMOTIONS isteği atılıyor...");
      print("Body: $requestBody");

      final response =
      await _dio.post('/Account/AddUserEmotions', data: requestBody);

      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ RESPONSE BODY: ${response.data}");

      if (response.statusCode == 200) {
        print('✅ Veri başarıyla gönderildi.');
      } else {
        print('❌ Hata: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ İstek sırasında hata oluştu: $e');
    }
  }

  // 📌 Description (global)
  Future<String> getDescription() async {
    try {
      print("➡️ GET Description isteği atılıyor...");

      final response = await _dio.get('/Account/GetDescription');

      print("⬅️ STATUS CODE: ${response.statusCode}");
      print("⬅️ RESPONSE DATA: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final description =
            data['descriptionText'] ?? data['DescriptionText'] ?? "";
        return description;
      } else if (response.statusCode == 404) {
        return "Kayıt bulunamadı";
      } else {
        return "Beklenmedik hata oluştu (${response.statusCode})";
      }
    } catch (e) {
      print("❌ Hata oluştu (DESCRIPTION): $e");
      return "Hata oluştu: $e";
    }
  }
}
