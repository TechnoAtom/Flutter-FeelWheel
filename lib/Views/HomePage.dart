import 'package:duygucarki/Views/Admin.dart';
import 'package:duygucarki/Views/Emotions.dart';
import 'package:duygucarki/Views/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'FirstStep.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, this.id, this.userName});

  final int? id; // 'id' nullable olabilir
  final String? userName;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final SequenceAnimation sequenceAnimation;

  final double radius = 60;
  bool _isLoading = false; // Yükleme durumu için değişken

  @override
  void initState() {
    super.initState();

    // Animasyon controller başlatılırken, controller'ın doğru şekilde başlatıldığından emin olalım.
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // Sequence animasyon başlatılması
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
        animatable: Tween<double>(begin: 0, end: 360),
        from: Duration(seconds: 0),
        to: Duration(seconds: 720),
        tag: "rotation")
        .animate(controller);

    // Animasyon başlatıldığında tekrarlaması sağlanır.
    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.repeat();
      }
    });

    // Controller'ı başlat
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    final double screenHeight = screenSize.size.height;
    final double screenWidth = screenSize.size.width;

    return Stack(
      children: [
        Scaffold(
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
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 180,
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                if(widget.id == 1) ...[
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text(
                      'Admin',
                      style:
                      TextStyle(fontFamily: 'Barlow Condensed', fontSize: 21),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Admin()));
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(
                    'Anasayfa',
                    style:
                    TextStyle(fontFamily: 'Barlow Condensed', fontSize: 21),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage(id:widget.id)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_emotions),
                  title: const Text(
                    'Duygularım',
                    style:
                    TextStyle(fontFamily: 'Barlow Condensed', fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Emotions(id:widget.id)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'Çıkış Yap',
                    style:
                    TextStyle(fontFamily: 'Barlow Condensed', fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginscreen()));
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight / 25),
              child: Container(
                height: 500,
                width: 500,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: sequenceAnimation["rotation"].value,
                          child: Container(
                            height: 350,
                            width: 350,
                            child: Image.asset('images/feelwheel.png'),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Firststep(id :widget.id)));
                        },
                        child: Container(
                          height: 100, // Dairenin yüksekliği
                          width: 100, // Dairenin genişliği (dairenin boyutu için eşit olmalı)
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F2D9), // Dairenin rengi
                            shape: BoxShape.circle, // Dairenin şeklini belirler
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4), // Gölgenin rengi
                                spreadRadius: 1, // Gölgenin yayılma oranı
                                blurRadius: 10, // Gölgenin bulanıklık derecesi
                                offset: Offset(0, 4), // Gölgenin kayma pozisyonu
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Başla', // Buraya istediğiniz yazıyı yazabilirsiniz
                              style: TextStyle(
                                fontSize: 25, // Yazının boyutu
                                fontWeight: FontWeight.bold, // Yazının kalınlığı
                                color: Colors.black, // Yazının rengi
                              ),
                            ),
                          ),
                        )

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Eğer _isLoading true ise tüm ekranı kaplayan yarı saydam katman ve progress indicator
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            // Ekranı karartmak için yarı saydam katman
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void _PageNavigate() async {
    setState(() {
      _isLoading = true; // Yükleme durumu başlat
    });

    // API isteğini simüle etmek için gecikme
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false; // Yükleme durumu bitti
      });

      // İlk adım sayfasına yönlendirin
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Firststep()),
      );
    }
  }
}
