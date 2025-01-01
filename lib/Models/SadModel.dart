
class Sadmodel {
  String uzgun ;

  String incinmis ;
  String zayif ;
  String yalniz;
  String bakimsiz;
  String utanmis ;
  String izoleolmus;

  String hayal;
  String motivasyonsuz ;
  String umutsuz;
  String ihaneteugramis;
  String umitduymayan ;
  String reddedilmis;

  bool _isVisible1 = false;
  bool _isVisible2 = false;

  Sadmodel({
    required this.uzgun,
    required this.incinmis,
    required this.zayif,
    required this.yalniz,
    required this.bakimsiz,
    required this.utanmis,
    required this.izoleolmus,
    required this.hayal,
    required this.motivasyonsuz,
    required this.umutsuz,
    required this.ihaneteugramis,
    required this.umitduymayan,
    required this.reddedilmis,
  });

  factory Sadmodel.defaultValues() {
    return Sadmodel(uzgun: "Üzgün",
        incinmis: "İncinmiş",
        zayif: "Zayıf",
        yalniz: "Yalnız",
        bakimsiz: "Bakımsız",
        utanmis: "Utanmış",
        izoleolmus: "İzole olmuş",
        hayal:"Hayal Kırıklığına\nUğramış",
        motivasyonsuz: "Motivasyonsuz",
        umutsuz: "Umutsuz",
        ihaneteugramis: "İhanete Uğramış",
        umitduymayan: "Ümit Duymayan",
        reddedilmis: "Reddedilmiş");
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