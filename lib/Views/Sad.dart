import 'dart:convert';

import 'package:duygucarki/Models/SadModel.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
Sadmodel sadmodel = Sadmodel.defaultValues();
class Sad extends StatefulWidget {
  final String sad;
  final int? id;

  const Sad({Key? key, required this.sad, this.id}) : super(key: key);

  @override
  State<Sad> createState() => _SadState();
}

class _SadState extends State<Sad> with WidgetsBindingObserver {
  bool _imagesLoaded = false;
  List<String> selectedemotions = [];
  bool _showProgressIndicator = false; // Progress indicator başlangıçta false
  late String oe;
  late String description;



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
    sadmodel.isVisible1 = false;
    sadmodel.isVisible2 = false;
  }

  void _launchURL(String oe) async {
    final Uri uri = Uri.parse(oe);  // URL'yi Uri nesnesine dönüştür

    // URL'nin açılabilir olup olmadığını kontrol et
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);  // URL'yi aç
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
    var image1 = AssetImage('images/sad1.png');
    var image2 = AssetImage('images/sad2.png');
    var image3 = AssetImage('images/sad3.png');

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
      _showProgressIndicator = !_showProgressIndicator; // Bu satırda state güncelleniyor
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setState(() {
        sadmodel.isVisible1 = false;
        sadmodel.isVisible2 = false;
      });
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {
        sadmodel.isVisible1 = false;
        sadmodel.isVisible2 = false;
      });
    }
  }

  //Get Link
  Future<String> getLink() async {
    final url = Uri.parse('https://apronmobil.com/Account/GetLink'); // API endpoint
    setLoading();
    try {
      final response = await http.get(url);  // HTTP isteği gönderiliyor

      // Durum kodlarına göre kontrol
      if (response.statusCode == 200) {
        oe = response.body;
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return response.body;
        // API'den gelen veriyi direkt olarak döndürüyoruz
      } else if (response.statusCode == 404) {
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return "Kayıt bulunamadı";  // Hata mesajı dönüyoruz
      } else {
        setLoading(); // Yükleme başlatıldığını belirtiyoruz
        return "Beklenmedik hata oluştu";  // Diğer hata durumları
      }
    } catch (e) {
      setLoading(); // Yükleme başlatıldığını belirtiyoruz
      return "Hata oluştu: $e";  // Hata durumunda dönecek mesaj
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
        backgroundColor: Color(0xFFca848a),
        title:  Text(widget.sad,
          style: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontSize: 28,
            fontWeight: FontWeight.w100,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                  height: scwidht * 1.2, // Dinamik olarak hesaplanmış yükseklik
                  width: scwidht * 0.90, // Ekran genişliğine göre
                  child: Stack(
                    children: [
                      // Arka planda yer alacak olan büyük görsel (angry3)
                      Visibility(
                        visible:sadmodel.isVisible2,
                        child: Positioned(
                          top: 0,
                          left: 0,
                          child: Image.asset(
                            'images/sad3.png',
                            width: scwidht * 0.90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Orta boyutlu görsel (angry2), biraz daha küçük ve ön planda
                      Visibility(
                        visible: sadmodel.isVisible1,
                        child: Positioned(
                          top: scwidht * 0.441,
                          // Üstten biraz aşağıda yer alacak
                          left: scwidht * 0.164,
                          // Sol taraftan biraz uzak
                          child: Image.asset(
                            'images/sad2.png',
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
                          'images/sad1.png',
                          width: scwidht * 0.308,
                          fit: BoxFit.cover,
                        ),
                      ),

                      //1. PARÇA DUYGULARI
                      _buildEmotionButton(context, sadmodel.uzgun, scwidht * 0.350,
                          scwidht * 0.835, 0, scwidht * 0.06, () {
                            selectedemotions.clear();
                            addFirstEmotion(sadmodel.uzgun);
                            setState(() {
                              sadmodel.toggleIsVisible1();
                              if (sadmodel.isVisible2 == true) {
                                sadmodel.toggleIsVisible2();
                              }
                            });
                          }, true),
                      //2.PARÇA DUYGULARI
                      _buildEmotionButton(context, sadmodel.incinmis, scwidht * 0.19,
                          scwidht * 0.68, 10.58, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.incinmis);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      _buildEmotionButton(context, sadmodel.zayif, scwidht * 0.295,
                          scwidht * 0.69, 10.70, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.zayif);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      _buildEmotionButton(context, sadmodel.yalniz, scwidht * 0.35,
                          scwidht * 0.67, 10.85, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.yalniz);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      _buildEmotionButton(context, sadmodel.bakimsiz, scwidht * 0.395,
                          scwidht * 0.645, 11.05, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.bakimsiz);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      _buildEmotionButton(context, sadmodel.utanmis, scwidht * 0.47,
                          scwidht * 0.66, 11.20, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.utanmis);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      _buildEmotionButton(context, sadmodel.izoleolmus, scwidht * 0.52,
                          scwidht * 0.65, 11.4, scwidht * 0.038, () {
                            addSecondEmotion(sadmodel.izoleolmus);
                            setState(() {
                              sadmodel.toggleIsVisible2();
                            });
                          }, sadmodel.isVisible1),
                      //3. PARÇA DUYGULARI
                      _buildEmotionButton(context, sadmodel.hayal, scwidht * 0,
                          scwidht * 0.26, 10.56, scwidht * 0.038, () {
                            addThirdEmotion(sadmodel.hayal);
                            sendSelectedEmotions(
                                widget.id, selectedemotions);
                            setState(() {});
                            showCustomDialog(context,oe);

                          }, sadmodel.isVisible2),

                      _buildEmotionButton(
                          context,
                          sadmodel.motivasyonsuz,
                          scwidht * 0.135,
                          scwidht * 0.24,
                          10.70,
                          scwidht * 0.040, () {
                        addThirdEmotion(sadmodel.motivasyonsuz);
                        sendSelectedEmotions(
                            widget.id, selectedemotions);
                        setState(() {});
                        showCustomDialog(context,oe);

                      },sadmodel.isVisible2),
                      _buildEmotionButton(context, sadmodel.umutsuz, scwidht * 0.32,
                          scwidht * 0.27, 10.90, scwidht * 0.040, () {
                            addThirdEmotion(sadmodel.umutsuz);
                            sendSelectedEmotions(
                                widget.id, selectedemotions);
                            setState(() {});
                            showCustomDialog(context,oe);

                          },sadmodel.isVisible2),
                      _buildEmotionButton(
                          context,
                          sadmodel.ihaneteugramis,
                          scwidht * 0.36,
                          scwidht * 0.20,
                          11.05,
                          scwidht * 0.040, () {
                        addThirdEmotion(sadmodel.ihaneteugramis);
                        sendSelectedEmotions(
                            widget.id, selectedemotions);
                        setState(() {});
                        showCustomDialog(context,oe);

                      },sadmodel.isVisible2),
                      _buildEmotionButton(context, sadmodel.umitduymayan, scwidht * 0.51,
                          scwidht * 0.23, 11.3, scwidht * 0.040, () {
                            addThirdEmotion(sadmodel.umitduymayan);
                            sendSelectedEmotions(
                                widget.id, selectedemotions);
                            setState(() {});
                            showCustomDialog(context,oe);

                          },sadmodel.isVisible2),
                      _buildEmotionButton(context, sadmodel.reddedilmis, scwidht * 0.65,
                          scwidht * 0.30, 11.40, scwidht * 0.040, () {
                            addThirdEmotion(sadmodel.reddedilmis);
                            sendSelectedEmotions(
                                widget.id, selectedemotions);
                            setState(() {});
                            showCustomDialog(context,oe);

                          },sadmodel.isVisible2),
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
                  visible: sadmodel.isVisible1,
                  child: Padding(
                    padding: EdgeInsets.all(scwidht * 0.05),
                    child: Text(
                      'Gerçek duygu durumunun farkında olarak, sorunlarının temelini öğrenebilirsin."Nasılsın?" sorusunun cevabı her zaman "iyiyim" değildir. Bu uygulama sana her gün "Nasılsın?" diye soracak.',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: scwidht * 0.03, // Adjust size dynamically
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
    );
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
  void showCustomDialog(BuildContext context,String oe) {
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
        content:Text(
          '${ selectedemotions[2].toString()}$description "${oe}"',
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
