import 'package:duygucarki/Views/HomePage.dart';
import 'package:duygucarki/Views/Register.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isChecked = false; // Checkbox durumu
  bool _isObscure = true; // Şifre gizli/görünür durumu
  bool _showProgressIndicator = false; // Progress indicator başlangıçta false

  @override
  void initState() {
    super.initState();
    usernameController.clear();
    passwordController.clear();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    var box = Hive.box('credentials');
    _isChecked = box.get('rememberMe') ?? false; // Varsayılan değer
    if (_isChecked) {
      usernameController.text =
          box.get('username') ?? ''; // Kullanıcı adını yükle
      passwordController.text = box.get('password') ?? ''; // Şifreyi yükle
    }
    setState(() {}); // Değişiklikleri yansıt
  }

  void logcabir() async {
    var box = Hive.box('credentials');
    String username = box.get('username') ?? ''; // Varsayılan değer
    String password = box.get('password') ?? ''; // Varsayılan değer
    String rememberMe =
        box.get('rememberMe')?.toString() ?? 'false'; // Varsayılan değer

    print("Kullanıcı adı: $username");
    print("Şifre: $password");
    print("Beni hatırla: $rememberMe");
  }

  void _saveRememberme(bool value) async {
    var box = Hive.box('credentials');
    await box.put('rememberMe', value);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // setLoading fonksiyonu
  void setLoading(bool value) {
    setState(() {
      _showProgressIndicator = value;
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
                            borderRadius:
                            BorderRadius.circular(20), // Köşe yuvarlama
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
                            borderRadius:
                            BorderRadius.circular(20), // Köşe yuvarlama
                          ),
                          hintText: 'Şifre',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure =
                                !_isObscure; // Şifreyi gizleme/gösterme işlevi
                              });
                            },
                          ),
                        ),
                        controller: passwordController,
                        obscureText: _isObscure, // Şifreyi gizli tut
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity, // Container'ı tam genişlikte yap
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Sağda hizala
                      children: [
                        const Text("Beni Hatırla"),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth / 30),
                          child: Checkbox(
                            value: _isChecked, // Checkbox durumu
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false; // Durumu güncelle
                                _saveRememberme(_isChecked);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (usernameController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Kullanıcı Adı Ve Şifre boş bırakılamaz.'),
                              action: SnackBarAction(
                                label: 'Anladım',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ));
                          } else {
                            Requests().checkRememberMe(usernameController,
                                passwordController, _isChecked);
                            logcabir();
                            Requests().login(
                              context,
                              usernameController,
                              passwordController,
                              setLoading, // _isLoading durumunu güncellemek için callback fonksiyonu
                            );
                          }
                        },
                        child:
                        const Text('Giriş Yap'), // Buton üzerindeki metin
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text('Kayıt Ol'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 50),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Vazgeç',
                                          style: TextStyle(
                                            fontFamily: 'Barlow Condensed',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        )),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Homepage()));
                                      },
                                      child: const Text(
                                        'Devam Et',
                                        style: TextStyle(
                                          fontFamily: 'Barlow Condensed',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              title: const Text('Uyarı'),
                              contentPadding: const EdgeInsets.all(20),
                              content: const Text(
                                'Üyeliksiz devam ettiğinde duygularını kaydedemeyeceksin :( \nOnaylıyorsan devam edebilirsin.',
                                style: TextStyle(
                                  fontFamily: 'Barlow Condensed',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 18,
                                ),
                              ),
                            ));
                        print("Tıklanabilir metin");
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Üyeliksiz devam et',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (_showProgressIndicator)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
