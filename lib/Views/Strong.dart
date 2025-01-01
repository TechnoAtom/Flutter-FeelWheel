import 'dart:convert';

import 'package:duygucarki/Models/StrongModel.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Strongmodel  strongmodel = Strongmodel.defaultValue();
class Strong extends StatefulWidget {
  final String strong;
  final int? id;

  const Strong({Key? key, required this.strong, this.id}) : super(key: key);

  @override
  State<Strong> createState() => _StrongState();
}

class _StrongState extends State<Strong> with WidgetsBindingObserver {
  bool _imagesLoaded = false;
  List<String> selectedemotions = [];
  bool _showProgressIndicator = false; // Progress indicator başlangıçta false
  late String oe;
  late String description;

  String url = "https://okyanusda.com/";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLink();
    getdescription();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    strongmodel.isVisible1 = false;
    strongmodel.isVisible2 = false;
  }

  void _launchURL(String oe) async {
    final Uri uri = Uri.parse(oe); // URL'yi Uri nesnesine dönüştür

    // URL'nin açılabilir olup olmadığını kontrol et
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL'yi aç
    } else {
      throw 'Bu URL açılamadı: $oe'; // Hata mesajı
    }
  }

  void addFirstEmotion(String emotion) {
    selectedemotions.insert(0, emotion);
  }

  void addSecondEmotion(String emotion) {
    if (selectedemotions.length > 1) {
      selectedemotions[1] = emotion; // 1. index'teki öğeyi değiştir
    } else {
      selectedemotions.insert(
          1, emotion); // Eğer 1. index'te öğe yoksa, yeni öğeyi ekle
    }
  }

  void addThirdEmotion(String emotion) {
    if (selectedemotions.length > 2) {
      selectedemotions[2] = emotion; // 1. index'teki öğeyi değiştir
    } else {
      selectedemotions.insert(
          2, emotion); // Eğer 1. index'te öğe yoksa, yeni öğeyi ekle
    }
  }

  void _loadImages() async {
    var image1 = AssetImage('images/strong1.png');
    var image2 = AssetImage('images/strong2.png');
    var image3 = AssetImage('images/strong3.png');

    await Future.wait([
      precacheImage(image1, context),
      precacheImage(image2, context),
      precacheImage(image3, context)
    ]);

    setState(() {
      _imagesLoaded = true;
    });
  }

  void setLoading() {
    setState(() {
      _showProgressIndicator =
      !_showProgressIndicator; // Bu satırda state güncelleniyor
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setState(() {

        strongmodel.isVisible1 = false;
        strongmodel.isVisible2 = false;
      });
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {

        strongmodel.isVisible1 = false;
        strongmodel.isVisible2 = false;
      });
    }
  }

  //Get Link
  Future<String> getLink() async {
    final url =
    Uri.parse('https://apronmobil.com/Account/GetLink'); // API endpoint
    setLoading();
    try {
      final response = await http.get(url); // HTTP isteği gönderiliyor

      // Durum kodlarına göre kontrol
      if (response.statusCode == 200) {
        oe = response.body;
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return response.body;
        // API'den gelen veriyi direkt olarak döndürüyoruz
      } else if (response.statusCode == 404) {
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return "Kayıt bulunamadı"; // Hata mesajı dönüyoruz
      } else {
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return "Beklenmedik hata oluştu"; // Diğer hata durumları
      }
    } catch (e) {
      setLoading(); // Yükleme başlatıldığını belirtiyoruz
      return "Hata oluştu: $e"; // Hata durumunda dönecek mesaj
    }
  }


  Future<String> getdescription() async {
    final url = Uri.parse('https://apronmobil.com/Account/GetDescription'); // API endpoint
    setLoading();  // Yükleme durumunu başlat

    try {
      final response = await http.get(url);  // HTTP isteği gönderiyoruz

      // Durum kodlarına göre kontrol
      if (response.statusCode == 200) {
        // JSON verisini çözümle
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // "description" alanını al
        description = jsonResponse['description'];

        setLoading();  // Yükleme durumunu sonlandır
        return description;  // Yalnızca description'ı döndürüyoruz

      } else if (response.statusCode == 404) {
        setLoading();  // Yükleme durumunu sonlandır
        return "Kayıt bulunamadı";  // Hata mesajı
      } else {
        setLoading();  // Yükleme durumunu sonlandır
        return "Beklenmedik hata oluştu";  // Diğer hata durumları
      }
    } catch (e) {
      setLoading();  // Yükleme durumunu sonlandır
      return "Hata oluştu: $e";  // Hata durumunda dönecek mesaj
    }
  }

  @override
  Widget build(BuildContext context) {
    var scsize = MediaQuery.of(context).size;
    double scheight = scsize.height;
    double scwidht = scsize.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFc8b273),
          title: Text(
            widget.strong,
            style: TextStyle(
              fontFamily: 'Barlow Condensed',
              fontSize: 28,
              fontWeight: FontWeight.w100,
            ),
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: scheight * 0.02),
                        height: scheight * 0.10,
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scheight * 0.03,
                  ),
                  // Stack içeren container
                  Column(
                    children: [
                      Container(
                        height: scwidht * 1.2,
                        // Dinamik olarak hesaplanmış yükseklik
                        width: scwidht * 0.90,
                        // Ekran genişliğine göre
                        child: Stack(
                          children: [
                            // Arka planda yer alacak olan büyük görsel (angry3)
                            Visibility(
                              visible: strongmodel.isVisible2,
                              child: Positioned(
                                top: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/strong3.png',
                                  width: scwidht * 0.90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Orta boyutlu görsel (angry2), biraz daha küçük ve ön planda
                            Visibility(
                              visible: strongmodel.isVisible1,
                              child: Positioned(
                                top: scwidht * 0.441,
                                // Üstten biraz aşağıda yer alacak
                                left: scwidht * 0.164,
                                // Sol taraftan biraz uzak
                                child: Image.asset(
                                  'images/strong2.png',
                                  width: scwidht * 0.568,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // En küçük görsel (angry1), diğerlerinin önünde
                            Positioned(
                              top: scwidht * 0.791,
                              left: scwidht * 0.2925,
                              child: Image.asset(
                                'images/strong1.png',
                                width: scwidht * 0.308,
                                fit: BoxFit.cover,
                              ),
                            ),

                            //1. PARÇA DUYGULARI
                            _buildEmotionButton(context, strongmodel.guclu, scwidht * 0.350,
                                scwidht * 0.835, 0, scwidht * 0.06, () {
                                  selectedemotions.clear();
                                  addFirstEmotion(strongmodel.guclu);
                                  setState(() {
                                    strongmodel.toggleIsVisible1();
                                    if (strongmodel.isVisible2 == true) {
                                      strongmodel.toggleIsVisible2();
                                    }
                                  });
                                }, true),
                            //2.PARÇA DUYGULARI
                            _buildEmotionButton(
                                context,
                                strongmodel.gururduymus,
                                scwidht * 0.12,
                                scwidht * 0.64,
                                10.58,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.gururduymus);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                strongmodel.gucsahibi,
                                scwidht * 0.245,
                                scwidht * 0.65,
                                10.70,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.gucsahibi);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                strongmodel. saygin,
                                scwidht * 0.355,
                                scwidht * 0.67,
                                10.85,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.saygin);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                strongmodel.degerli,
                                scwidht * 0.418,
                                scwidht * 0.665,
                                11.08,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.degerli);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                strongmodel.saygideger,
                                scwidht * 0.461,
                                scwidht * 0.645,
                                11.20,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.saygideger);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                strongmodel.korkusuz,
                                scwidht * 0.535,
                                scwidht * 0.675,
                                11.4,
                                scwidht * 0.038, () {
                              addSecondEmotion(strongmodel.korkusuz);
                              setState(() {
                                strongmodel.toggleIsVisible2();
                              });
                            }, strongmodel.isVisible1),
                            //3. PARÇA DUYGULARI
                            _buildEmotionButton(context, strongmodel.onemli, scwidht * 0.10,
                                scwidht * 0.25, 10.7, scwidht * 0.038, () {
                                  addThirdEmotion(strongmodel.onemli);
                                  sendSelectedEmotions(
                                      widget.id, selectedemotions);
                                  setState(() {});
                                  showCustomDialog(context, oe);
                                }, strongmodel.isVisible2),
                            _buildEmotionButton(context, strongmodel.azimli, scwidht * 0.11,
                                scwidht * 0.36, 10.60, scwidht * 0.040, () {
                                  addThirdEmotion(strongmodel.azimli);
                                  sendSelectedEmotions(
                                      widget.id, selectedemotions);
                                  setState(() {});
                                  showCustomDialog(context, oe);
                                }, strongmodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                strongmodel.guclenmisgibi,
                                scwidht * 0.22,
                                scwidht * 0.22,
                                10.85,
                                scwidht * 0.040, () {
                              addThirdEmotion(strongmodel.guclenmisgibi);
                              sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, strongmodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                strongmodel.basarili,
                                scwidht * 0.42,
                                scwidht * 0.29,
                                11.05,
                                scwidht * 0.040, () {
                              addThirdEmotion(strongmodel.basarili);
                              sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, strongmodel.isVisible2),
                            _buildEmotionButton(context, strongmodel.zeki, scwidht * 0.56,
                                scwidht * 0.33, 11.3, scwidht * 0.040, () {
                                  addThirdEmotion(strongmodel.zeki);
                                  sendSelectedEmotions(
                                      widget.id, selectedemotions);
                                  setState(() {});
                                  showCustomDialog(context, oe);
                                }, strongmodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                strongmodel.kendindenemin,
                                scwidht * 0.58,
                                scwidht * 0.26,
                                11.40,
                                scwidht * 0.040, () {
                              addThirdEmotion(strongmodel.kendindenemin);
                              sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, strongmodel.isVisible2),
                          ],
                        ),
                      ),
                      Text(
                        'Bugün aslında nasıl hissediyorsun ?',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: scwidht * 0.045, // Adjust size dynamically
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                      ),
                      Visibility(
                        visible: strongmodel.isVisible1,
                        child: Padding(
                          padding: EdgeInsets.all(scwidht * 0.05),
                          child: Text(
                            'Gerçek duygu durumunun farkında olarak, sorunlarının temelini öğrenebilirsin."Nasılsın?" sorusunun cevabı her zaman "iyiyim" değildir. Bu uygulama sana her gün "Nasılsın?" diye soracak.',
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize:
                              scwidht * 0.03, // Adjust size dynamically
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
        ));
  }

  // _buildEmotionButton fonksiyonuna context parametresi ekledik
  Widget _buildEmotionButton(
      BuildContext context,
      String emotion,
      double left,
      double top,
      double rotationAngle,
      double fontsize,
      VoidCallback onTap,
      bool isVisible) {
    return Padding(
      padding: EdgeInsets.only(left: left, top: top),
      child: Transform.rotate(
        angle: rotationAngle, // Custom rotation angle for each button
        child: Material(
          color: Colors.transparent, // Görsel efektler için transparent renk
          child: Visibility(
            visible: isVisible, // Burada Visibility kontrolü yapılıyor
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withOpacity(0.2),
              // Dalgalanma efekti rengi
              highlightColor: Colors.white.withOpacity(0.1),
              // Vurgulama rengi
              child: Padding(
                padding: const EdgeInsets.all(1.0), // Buton içindeki boşluk
                child: Text(
                  emotion,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: fontsize,
                    color: Colors.black, // Buton metni rengi
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dialog fonksiyonunu burada tanımlıyoruz
  void showCustomDialog(BuildContext context, String oe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
                child: const Text(
                  'Vazgeç',
                  style: TextStyle(
                    fontFamily: 'Barlow Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _launchURL(oe);
                  print('Ziyaret Et tıklandı');
                },
                child: const Text(
                  'Ziyaret Et',
                  style: TextStyle(
                    fontFamily: 'Barlow Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
        title: const Text('Uyarı'),
        contentPadding: const EdgeInsets.all(20),
        content: Text(
          '${ selectedemotions[2].toString()}$description "${url}"',
          style: const TextStyle(
            fontFamily: 'Barlow Condensed',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w200,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

