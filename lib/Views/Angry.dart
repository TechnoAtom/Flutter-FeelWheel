import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:duygucarki/Models/AngryModel.dart';
import 'package:duygucarki/Views/Requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

AngryModel angryModel = AngryModel.defaultValues();

class Angry extends StatefulWidget {
  final String angry;
  final int? id;

  const Angry({Key? key, required this.angry, this.id}) : super(key: key);

  @override
  State<Angry> createState() => _ScaredState();
}

class _ScaredState extends State<Angry> with WidgetsBindingObserver {
  bool _imagesLoaded = false;
  final List<String> selectedemotions = [];
  bool _showProgressIndicator = false;
  String oe = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLink();
    _ensureDescriptionLoaded(); // İlk açılışta bir kez çek
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    angryModel.isVisible1 = false;
    angryModel.isVisible2 = false;
    super.dispose();
  }

  // --- Helpers ---------------------------------------------------------------

  Future<void> _ensureDescriptionLoaded() async {
    if (description.isEmpty) {
      final value = await Requests().getDescription();
      if (!mounted) return;
      setState(() => description = value);
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Bu URL açılamadı: $url');
    }
  }

  void addFirstEmotion(String emotion) {
    if (selectedemotions.isEmpty) {
      selectedemotions.add(emotion);
    } else {
      selectedemotions[0] = emotion;
    }
  }

  void addSecondEmotion(String emotion) {
    if (selectedemotions.length > 1) {
      selectedemotions[1] = emotion;
    } else {
      selectedemotions.length == 0
          ? selectedemotions.addAll([ "", emotion ])
          : selectedemotions.add(emotion);
    }
  }

  void addThirdEmotion(String emotion) {
    if (selectedemotions.length > 2) {
      selectedemotions[2] = emotion;
    } else {
      // eksik indeksleri doldur
      while (selectedemotions.length < 2) {
        selectedemotions.add("");
      }
      selectedemotions.add(emotion);
    }
  }

  void setLoading() {
    if (!mounted) return;
    setState(() {
      _showProgressIndicator = !_showProgressIndicator;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.resumed) {
      setState(() {
        angryModel.isVisible1 = false;
        angryModel.isVisible2 = false;
      });
    }
  }

  // --- API -------------------------------------------------------------------

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

  // --- UI --------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final scsize = MediaQuery.of(context).size;
    final scheight = scsize.height;
    final scwidht  = scsize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFde8c59),
        title: Text(
          widget.angry,
          style: const TextStyle(
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
                SizedBox(height: scheight * 0.03),

                // Ana içerik
                Column(
                  children: [
                    Container(
                      height: scwidht * 1.2,
                      width: scwidht * 0.90,
                      child: Stack(
                        children: [
                          // Arka plan görsel
                          Visibility(
                            visible: angryModel.isVisible2,
                            child: Positioned(
                              top: 0,
                              left: 0,
                              child: Image.asset(
                                'images/angry3.png',
                                width: scwidht * 0.90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Orta görsel
                          Visibility(
                            visible: angryModel.isVisible1,
                            child: Positioned(
                              top: scwidht * 0.441,
                              left: scwidht * 0.164,
                              child: Image.asset(
                                'images/angry2.png',
                                width: scwidht * 0.568,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Ön görsel
                          Positioned(
                            top: scwidht * 0.791,
                            left: scwidht * 0.2925,
                            child: Image.asset(
                              'images/angry1.png',
                              width: scwidht * 0.308,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // 1. halka
                          _buildEmotionButton(
                            context,
                            angryModel.kizgin,
                            scwidht * 0.355,
                            scwidht * 0.835,
                            0,
                            scwidht * 0.06,
                                () {
                              selectedemotions.clear();
                              addFirstEmotion(angryModel.kizgin);
                              setState(() {
                                angryModel.toggleIsVisible1();
                                if (angryModel.isVisible2) {
                                  angryModel.toggleIsVisible2();
                                }
                              });
                            },
                            true,
                          ),

                          // 2. halka
                          _buildEmotionButton(
                            context,
                            angryModel.ofkeli,
                            scwidht * 0.235,
                            scwidht * 0.715,
                            10.58,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.ofkeli);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.rahatsizedilmis,
                            scwidht * 0.18,
                            scwidht * 0.602,
                            10.75,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.rahatsizedilmis);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.caniacimis,
                            scwidht * 0.305,
                            scwidht * 0.635,
                            10.88,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.caniacimis);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.nefretdolu,
                            scwidht * 0.38,
                            scwidht * 0.635,
                            11.08,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.nefretdolu);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.huysuz,
                            scwidht * 0.48,
                            scwidht * 0.68,
                            11.20,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.huysuz);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.kiskanc,
                            scwidht * 0.54,
                            scwidht * 0.695,
                            11.4,
                            scwidht * 0.038,
                                () {
                              addSecondEmotion(angryModel.kiskanc);
                              setState(() => angryModel.toggleIsVisible2());
                            },
                            angryModel.isVisible1,
                          ),

                          // 3. halka (nihai seçimler)
                          _buildEmotionButton(
                            context,
                            angryModel.agresif,
                            scwidht * 0.085,
                            scwidht * 0.35,
                            10.56,
                            scwidht * 0.038,
                                () async {
                              addThirdEmotion(angryModel.agresif);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.agirlikcokmus,
                            scwidht * 0.080,
                            scwidht * 0.24,
                            10.70,
                            scwidht * 0.040,
                                () async {
                              addThirdEmotion(angryModel.agirlikcokmus);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.igrenmis,
                            scwidht * 0.275,
                            scwidht * 0.27,
                            10.82,
                            scwidht * 0.040,
                                () async {
                              addThirdEmotion(angryModel.igrenmis);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.husranaugramis,
                            scwidht * 0.325,
                            scwidht * 0.182,
                            11.05,
                            scwidht * 0.040,
                                () async {
                              addThirdEmotion(angryModel.husranaugramis);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.dusmanca,
                            scwidht * 0.50,
                            scwidht * 0.26,
                            11.2,
                            scwidht * 0.040,
                                () async {
                              addThirdEmotion(angryModel.dusmanca);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                          _buildEmotionButton(
                            context,
                            angryModel.rahatsizlikduymus,
                            scwidht * 0.615,
                            scwidht * 0.235,
                            11.40,
                            scwidht * 0.040,
                                () async {
                              addThirdEmotion(angryModel.rahatsizlikduymus);
                              Requests().sendSelectedEmotions(widget.id, selectedemotions);
                              setState(() {});
                              await _ensureDescriptionLoaded();
                              if (!mounted) return;
                              showCustomDialog(context, oe);
                            },
                            angryModel.isVisible2,
                          ),
                        ],
                      ),
                    ),

                    Text(
                      'Bugün aslında nasıl hissediyorsun ?',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: scwidht * 0.045,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),

                    Visibility(
                      visible: angryModel.isVisible1,
                      child: Padding(
                        padding: EdgeInsets.all(scwidht * 0.05),
                        child: Text(
                          'Gerçek duygu durumunun farkında olarak, sorunlarının temelini öğrenebilirsin."Nasılsın?"sorusunun cevabı her zaman "iyiyim" değildir. Bu uygulama sana her gün "Nasılsın?" diye soracak.',
                          style: TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: scwidht * 0.03,
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
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // --- Widgets ---------------------------------------------------------------

  Widget _buildEmotionButton(
      BuildContext context,
      String emotion,
      double left,
      double top,
      double rotationAngle,
      double fontsize,
      VoidCallback onTap,
      bool isVisible,
      ) {
    return Padding(
      padding: EdgeInsets.only(left: left, top: top),
      child: Transform.rotate(
        angle: rotationAngle,
        child: Material(
          color: Colors.transparent,
          child: Visibility(
            visible: isVisible,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  emotion,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: fontsize,
                    color: Colors.black,
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
