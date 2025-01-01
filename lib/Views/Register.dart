import 'package:duygucarki/Views/LoginScreen.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http paketini eklemeyi unutmayın
import 'dart:convert'; // jsonEncode için gerekli

import 'Homepage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false; // Yükleme durumu için bir değişken
  bool _isObscure = true; // Şifre gizleme durumu

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context);
    final double screenHeight = screensize.size.height;
    final double screenWidth = screensize.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: screenWidth / 2,
                    child: Image.asset('images/logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: 50,
                      width: screenWidth * 0.90,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Kullanıcı Adı veya E-Posta',
                        ),
                        controller: usernameController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 50),
                    child: SizedBox(
                      height: 50,
                      width: screenWidth * 0.90,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Şifre',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        controller: passwordController,
                        obscureText: _isObscure, // Şifreyi gizli tut
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: ElevatedButton(
                      onPressed: () {
                        if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Kullanıcı Adı Ve Şifre boş bırakılamaz.'),
                              action: SnackBarAction(
                                label: 'Anladım',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        } else {
                          Requests().postRegister(
                            context,
                            usernameController,
                            passwordController,
                            setLoading,  // Bu şekilde fonksiyonu geçiyoruz
                            _showErrorDialog,
                          );
                        }
                      },
                      child: const Text('Kayıt Ol',style: TextStyle(fontSize: 18),),
                    ),
                  ),
                  Text('Veya',style: TextStyle(fontSize: 15),),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>Loginscreen() ));

                    },
                    child: Text('Giriş Yap',style: TextStyle(fontSize: 15,color: Colors.lightBlue),),
                  )
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Yarı saydam siyah arka plan
                child: const Center(
                  child: CircularProgressIndicator(), // Yükleniyor göstergesi
                ),
              ),
            ),
        ],
      ),
    );
  }



  // Hata mesajlarını UI'de göstermek için callback fonksiyonu
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uyarı'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
            ),
          ],
        );
      },
    );
  }

}
