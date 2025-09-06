import 'dart:convert';

import 'package:duygucarki/Models/HappyModel.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Happymodel happymodel = Happymodel.defaultValues();

class Happy extends StatefulWidget {
  final String happy;
  final int? id;

  const Happy({Key? key, required this.happy, this.id}) : super(key: key);

  @override
  State<Happy> createState() => _HappyState();
}

class _HappyState extends State<Happy> with WidgetsBindingObserver {
  bool _imagesLoaded = false;
  List<String> selectedemotions = [];
  bool _showProgressIndicator = false; // Progress indicator başlangıçta false
  String oe = "";
  String description = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLink();
    _ensureDescriptionLoaded();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    happymodel.isVisible1 = false;
    happymodel.isVisible2 = false;
  }

  Future<void> _ensureDescriptionLoaded() async {
    if (description.isEmpty) {
      final value = await Requests().getDescription();
      if (!mounted) return;
      setState(() => description = value);
    }
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

  void setEmotion(int index, String emotion) {
    if (selectedemotions.length <= index) {
      selectedemotions.addAll(
          List.filled(index - selectedemotions.length + 1, ''));
    }
    selectedemotions[index] = emotion;
  }

  void _loadImages() async {
    var image1 = AssetImage('images/happy1.png');
    var image2 = AssetImage('images/happy2.png');
    var image3 = AssetImage('images/happy3.png');

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
        happymodel.isVisible1 = false;
        happymodel.isVisible2 = false;
      });
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {
        happymodel.isVisible1 = false;
        happymodel.isVisible2 = false;
      });
    }
  }

  //Get Link
  // Link'i çeker
  Future<String> getLink() async {
    final url = Uri.parse('${Requests.baseUrl}/Account/GetLink');
    setLoading();

    print("➡️ GET isteği atılıyor...");
    print("URL: $url");

    try {
      final response = await http.get(url);

      print("⬅️ STATUS CODE: ${response.statusCode}");
      print("⬅️ RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        oe = response.body;
        setLoading();
        return oe;
      } else if (response.statusCode == 404) {
        setLoading();
        return "Kayıt bulunamadı";
      } else {
        setLoading();
        return "Beklenmedik hata oluştu";
      }
    } catch (e) {
      print("❌ Hata oluştu: $e");
      setLoading();
      return "Hata oluştu: $e";
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
          backgroundColor: Color(0xFF6ba4b8),
          title: Text(
            widget.happy,
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
                              visible: happymodel.isVisible2,
                              child: Positioned(
                                top: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/happy3.png',
                                  width: scwidht * 0.90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Orta boyutlu görsel (angry2), biraz daha küçük ve ön planda
                            Visibility(
                              visible: happymodel.isVisible1,
                              child: Positioned(
                                top: scwidht * 0.441,
                                // Üstten biraz aşağıda yer alacak
                                left: scwidht * 0.164,
                                // Sol taraftan biraz uzak
                                child: Image.asset(
                                  'images/happy2.png',
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
                                'images/happy1.png',
                                width: scwidht * 0.308,
                                fit: BoxFit.cover,
                              ),
                            ),

                            //1. PARÇA DUYGULARI
                            _buildEmotionButton(
                                context,
                                happymodel.mutlu,
                                scwidht * 0.357,
                                scwidht * 0.835,
                                0,
                                scwidht * 0.06, () {
                              selectedemotions.clear();
                              setEmotion(0, happymodel.mutlu);
                              setState(() {
                                happymodel.toggleIsVisible1();
                                if (happymodel.isVisible2 == true) {
                                  happymodel.toggleIsVisible2();
                                }
                              });
                            }, true),
                            //2.PARÇA DUYGULARI
                            _buildEmotionButton(
                                context,
                                happymodel.neseli,
                                scwidht * 0.225,
                                scwidht * 0.70,
                                10.58,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.neseli);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                happymodel.keyifli,
                                scwidht * 0.295,
                                scwidht * 0.675,
                                10.70,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.keyifli);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                happymodel.zevkalmis,
                                scwidht * 0.31,
                                scwidht * 0.62,
                                10.85,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.zevkalmis);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                happymodel.sevinmis,
                                scwidht * 0.40,
                                scwidht * 0.638,
                                11.05,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.sevinmis);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                happymodel.eglenmis,
                                scwidht * 0.465,
                                scwidht * 0.645,
                                11.20,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.eglenmis);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            _buildEmotionButton(
                                context,
                                happymodel.nesesacan,
                                scwidht * 0.52,
                                scwidht * 0.645,
                                11.38,
                                scwidht * 0.038, () {
                              setEmotion(1, happymodel.nesesacan);
                              setState(() {
                                happymodel.toggleIsVisible2();
                              });
                            }, happymodel.isVisible1),
                            //3. PARÇA DUYGULARI
                            _buildEmotionButton(
                                context,
                                happymodel.memnun,
                                scwidht * 0.07,
                                scwidht * 0.32,
                                10.56,
                                scwidht * 0.038, () {
                              setEmotion(2, happymodel.memnun);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),

                            _buildEmotionButton(
                                context,
                                happymodel.cokeglenmis,
                                scwidht * 0.125,
                                scwidht * 0.23,
                                10.70,
                                scwidht * 0.040, () {
                              setEmotion(2, happymodel.cokeglenmis);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                happymodel.hevesli,
                                scwidht * 0.31,
                                scwidht * 0.26,
                                10.90,
                                scwidht * 0.040, () {
                              setEmotion(2, happymodel.hevesli);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                happymodel.hosnutolmus,
                                scwidht * 0.36,
                                scwidht * 0.19,
                                11.05,
                                scwidht * 0.040, () {
                              setEmotion(2, happymodel.hosnutolmus);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                happymodel.heyecanli,
                                scwidht * 0.53,
                                scwidht * 0.25,
                                11.25,
                                scwidht * 0.040, () {
                              setEmotion(2, happymodel.heyecanli);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),
                            _buildEmotionButton(
                                context,
                                happymodel.tutkulu,
                                scwidht * 0.66,
                                scwidht * 0.305,
                                11.40,
                                scwidht * 0.040, () {
                              setEmotion(2, happymodel.tutkulu);
                              Requests().sendSelectedEmotions(
                                  widget.id, selectedemotions);
                              setState(() {});
                              showCustomDialog(context, oe);
                            }, happymodel.isVisible2),
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
                        visible: happymodel.isVisible1,
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
  void showCustomDialog(BuildContext context, String url) {
    final emo = selectedemotions.length >= 3 ? selectedemotions[2] : "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uyarı'),
        contentPadding: const EdgeInsets.all(20),
        content: Text(
          (description.isNotEmpty)
              ? description
              : 'Yükleniyor...',
          style: const TextStyle(
            fontFamily: 'Barlow Condensed',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w200,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Vazgeç",
              style: TextStyle(
                fontFamily: 'Barlow Condensed',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w200,
                fontSize: 20,
              ),
            ),
          ),
          // İstersen link açma butonunu geri aç:
          // TextButton(
          //   onPressed: () => _launchURL(url),
          //   child: const Text('Ziyaret Et'),
          // ),
        ],
      ),
    );
  }
}
