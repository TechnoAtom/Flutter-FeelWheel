class Scaredmodel {

  String korkmus;

  //second
  String guvensiz;
  String gergin;
  String panikicinde;
  String endiseli;
  String sokolmus;
  String stresli;

  //third
  String kaygicinde;
  String supheicinde;
  String ezilmis;
  String heyecandangerilmis;
  String paranoya;
  String kafasikarisik;

  bool _isVisible1 = false;
  bool _isVisible2 = false;


  Scaredmodel({
    required this.korkmus,
    required this.guvensiz,
    required this.panikicinde,
    required this.kafasikarisik,
    required this.paranoya,
    required this.heyecandangerilmis,
    required this.ezilmis,
    required this.supheicinde,
    required this.kaygicinde,
    required this.stresli,
    required this.sokolmus,
    required this.endiseli,
    required this.gergin,
  });

  factory Scaredmodel.defaultValue(){
    return Scaredmodel(korkmus: "Korkmuş",
        guvensiz: "Güvensiz",
        panikicinde: "Panik İçinde",
        kafasikarisik: "Kafası Karışık",
        paranoya: "Paranoya",
        heyecandangerilmis:"Heyecandan\nGerilmiş",
        ezilmis: "Ezilmiş",
        supheicinde: "Şüphe İçinde",
        kaygicinde: "Kaygı İçinde",
        stresli: "Stresli",
        sokolmus: "Şok Olmuş",
        endiseli: "Endişeli",
        gergin: "Gergin");
  }
  // Getter ve Setter'lar
  bool get isVisible1 => _isVisible1;
  set isVisible1(bool value) {
    _isVisible1 = value;
  }

  bool get isVisible2 => _isVisible2;
  set isVisible2(bool value) {
    _isVisible2 = value;
  }

  // Bu değerleri kontrol etmek için ek metotlar da ekleyebilirsin
  void toggleIsVisible1() {
    _isVisible1 = !_isVisible1;
  }

  void toggleIsVisible2() {
    _isVisible2 = !_isVisible2;
  }

}