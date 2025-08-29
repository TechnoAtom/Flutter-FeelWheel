import 'package:flutter/material.dart';

class Secondstep extends StatefulWidget {
  const Secondstep({
    super.key,
    this.emotion = "Default Emotion", // Varsayılan değer
    this.images = "", // İsteğe bağlı, varsayılan değer
    this.imagem = "", // İsteğe bağlı, varsayılan değer
    this.imagel = "",
    this.scared1 = const [],  // Varsayılan boş liste
    this.scared2 = const [],
    this.calm1 = const [],
    this.calm2 = const [],
    this.strong1 = const [],
    this.strong2 = const [],
    this.angry1 = const [],
    this.angry2 = const [],
    this.sad1 = const [],
    this.sad2 = const [],
    this.happy1 = const [],
    this.happy2 = const [],
//
  });

  final String emotion; // Zorunlu değil
  final String images;  // Zorunlu değil
  final String imagem;  // Zorunlu değil
  final String imagel;  // Zorunlu değil
  final List<String> scared1;  // Zorunlu değil, final ekledik
  final List<String> scared2;  // Zorunlu değil, final ekledik
  final List<String> calm1;  // Zorunlu değil, final ekledik
  final List<String> calm2;  // Zorunlu değil, final ekledik
  final List<String> strong1;  // Zorunlu değil, final ekledik
  final List<String> strong2;  // Zorunlu değil, final ekledik
  final List<String> angry1;  // Zorunlu değil, final ekledik
  final List<String> angry2;  // Zorunlu değil, final ekledik
  final List<String> sad1;  // Zorunlu değil, final ekledik
  final List<String> sad2;  // Zorunlu değil, final ekledik
  final List<String> happy1;  // Zorunlu değil, final ekledik
  final List<String> happy2;  // Zorunlu değil, final ekledik


  @override
  State<Secondstep> createState() => _SecondstepState();
}

class _SecondstepState extends State<Secondstep> {
  bool showfirstimage = false;
  bool showsecondimg = false;

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    double scheight = screensize.height;
    double scwidth = screensize.width;

    String angry = 'angry';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emotion),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('qwdqdöqwdqödqö'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('qwdqdöqwdqödqö'),
                    ],
                  )
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // İkinci resim
                if (showsecondimg) ...[
                  Padding(
                    padding:EdgeInsets.only(top: scheight * 0.134),
                    child: Image.asset(
                      widget.imagel.isNotEmpty
                          ? 'images/${widget.imagel}'
                          : 'assets/placeholder.png',
                    ),
                  ),
                  /*  Padding(
                    padding:EdgeInsets.only(top:scwidth * 0.10),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Text('null',
                        style: TextStyle(
                          fontFamily: 'Barlow Condensed',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w800,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ), */
                ],

                if (showfirstimage) ...[
                  Padding(
                    padding:EdgeInsets.only(top: scheight * 0.358,),
                    child: Image.asset(
                      widget.imagem.isNotEmpty
                          ? 'images/${widget.imagem}'
                          : 'assets/placeholder.png',
                    ),
                  ),

                  //yazılar
                  Padding(
                    padding:EdgeInsets.only(right:scwidth * 0.35,top :scheight * 0.22),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle: 42.05,
                        child: Text(widget.happy2.length > 2 ? widget.angry2[2].toString() : 'Default Text',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(right:scwidth * 0.32 , top : scheight * 0.030),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle: 42.15,
                        child: Text('Gergin',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(right:scwidth * 0.12 , top : scwidth * 0.48),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle: 42.30,
                        child: Text('Güvensiz',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:scwidth * 0.10 , top : scwidth * 0.50),
                    child:GestureDetector(

                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle: 42.50,
                        child: Text('Endişeli',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left :scwidth * 0.32 , top : scwidth * 0.48),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle: 42.74,
                        child: Text('Şok Olmuş',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:scwidth * 0.30, top : scwidth * 0.030),
                    child:GestureDetector(
                      onTap: () {
                        setState(() {
                          showsecondimg = !showsecondimg;
                        });
                      },
                      child: Transform.rotate(
                        angle:42.58,
                        child: Text('Stresli',
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing:0.8
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                // Üçüncü resim
                Padding(
                  padding: EdgeInsets.only(top: scheight * 0.58,), // %10 boşluk
                  child: Image.asset(
                    widget.images.isNotEmpty
                        ? 'images/${widget.images}'
                        : 'assets/placeholder.png',
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top:scwidth * 0.95),
                  child:GestureDetector(
                    onTap: () {
                      setState(() {
                        showfirstimage = !showfirstimage;
                        if(showsecondimg ==true)
                        {
                          showsecondimg = !showsecondimg;

                        }
                      });
                    },
                    child: Text(widget.emotion,
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
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
}
