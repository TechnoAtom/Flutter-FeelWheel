import 'package:duygucarki/Views/Angry.dart';
import 'package:duygucarki/Views/Calm.dart';
import 'package:duygucarki/Views/Happy.dart';
import 'package:duygucarki/Views/LoginScreen.dart';
import 'package:duygucarki/Views/Sad.dart';
import 'package:duygucarki/Views/Scared.dart';
import 'package:duygucarki/Views/Strong.dart';
import 'package:flutter/material.dart';

class Firststep extends StatefulWidget {
  final int? id;
  const Firststep({Key? key,this.id}) : super(key: key);

  @override
  State<Firststep> createState() => _FirststepState();
}

class _FirststepState extends State<Firststep> with WidgetsBindingObserver {
  bool _imagesLoaded = false;

  String sad = "Üzgün";
  String scared = "Korkmuş";
  String angry = "Kızgın";
  String strong = "Güçlü";
  String happy = "Mutlu";
  String calm = "Sakin";

  String mainfont = "Open Sans";

  // _loadImages method to load images asynchronously
  void _loadImages() async {
    var image1 = AssetImage(
      'images/feelwheel.png',
    );
    await Future.wait([precacheImage(image1, context)]);
    setState(() {
      _imagesLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scsize = MediaQuery.of(context).size;
    double scheight = scsize.height;
    double scwidht = scsize.width;

    // Responsively set font size and spacing based on screen height and width
    double fontSize = scheight * 0.04;
    double padding = scwidht * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC98A8F),
        title: const Text(
          'Duygu Çarkı',
          style: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontSize: 28,
            fontWeight: FontWeight.w100,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Loginscreen()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: Color(0xFFDEC2BD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo Image
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
            // Description Text
            Container(
              child: Text(
                'Gerçek duygu durumunun farkında olarak, sorunlarının temelini öğrenebilirsin."Nasılsın?" sorusunun cevabı her zaman "iyiyim" değildir. Bu uygulama sana her gün "Nasılsın?" diye soracak.',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: Color(0xFF808080),
                  fontSize: fontSize * 0.45,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(height: scwidht * 0.05),
            // Question Text
            Container(
              width: double.infinity,
              color: Color(0xFFF2F2D9),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: scheight / 29),
                    child: Text(
                      'Bugün aslında nasıl hissediyorsun ?',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: fontSize * 0.80, // Adjust size dynamically
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: scheight / 31),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image in the background
                      Container(
                        // Container boyutunu ekran boyutuna göre ayarlıyoruz
                        height: scwidht * 0.90,
                        width: scwidht * 0.90,
                        child: Stack(
                          children: [
                            // Resim, ekran boyutuna göre esnek bir şekilde ayarlanacak
                            Image.asset(
                              'images/feelwheel.png',
                              height: scwidht * 0.90,
                              width: scwidht *
                                  0.90, // Resmin yüksekliği Container'a uyacak şekilde
                            ),
                            Container(
                              child: Stack(
                                children: [
                                  _buildEmotionButton(sad, scwidht * 0.165,
                                      scwidht * 0.11, 11.88, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Sad(sad: sad , id : widget.id)));
                                      }),
                                  _buildEmotionButton(scared, scwidht * 0.51,
                                      scwidht * 0.11, 13.15, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Scared(scared: scared , id : widget.id)));
                                      }),
                                  _buildEmotionButton(angry, scwidht * 0.73,
                                      scwidht * 0.43, 29.85, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Angry(angry: angry , id : widget.id)));
                                      }),
                                  _buildEmotionButton(strong, scwidht * 0.54,
                                      scwidht * 0.72, 18.28, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Strong(strong:strong, id : widget.id)));
                                      }),
                                  _buildEmotionButton(happy, scwidht * 0.19,
                                      scwidht * 0.725, 25.65, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Happy(happy : happy, id : widget.id)));
                                      }),
                                  _buildEmotionButton(calm, scwidht * 0.02,
                                      scwidht * 0.43, 36.1, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Calm(calm : calm, id : widget.id)));
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scheight * 0.07,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build emotion buttons responsively with rotation angle
  Widget _buildEmotionButton(String emotion, double left, double top,
      double rotationAngle, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(left: left, top: top),
      child: Transform.rotate(
        angle: rotationAngle, // Custom rotation angle for each button
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            emotion,
            style: TextStyle(
              fontFamily: mainfont,
              fontSize: MediaQuery.of(context).size.width * 0.058,
            ),
          ),
        ),
      ),
    );
  }
}
