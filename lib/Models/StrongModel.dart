
class Strongmodel {
  String guclu = "Güçlü";

  String gururduymus = "Gurur Duymuş";
  String gucsahibi = "Güç Sahibi";
  String saygin = "Saygın";
  String degerli = "Değerli";
  String saygideger = "Saygıdeğer";
  String korkusuz = "Korkusuz";

  String onemli = "Önemli Biri Gibi";
  String azimli = "Azimli";
  String guclenmisgibi = "Güçlenmiş Gibi";
  String basarili = "Başarılı";
  String zeki = "Zeki";
  String kendindenemin = "Kendinden Emin";

  bool _isVisible1 = false;
  bool _isVisible2 = false;

  Strongmodel({
    required this.kendindenemin,
    required this.zeki,
    required this.basarili,
    required this.guclenmisgibi,
    required this.azimli,
    required this.korkusuz,
    required this.saygideger,
    required this.degerli,
    required this.saygin,
    required this.gucsahibi,
    required this.gururduymus,
    required this.guclu,
    required this.onemli,
  });

  factory Strongmodel.defaultValue(){
    return Strongmodel(kendindenemin: "Kendinden Emin",
        zeki: "Zeki",
        basarili: "Başarılı",
        guclenmisgibi: "Güçlenmiş Gibi",
        azimli: "Azimli",
        korkusuz: "Korkusuz",
        saygideger: "Saygıeğer",
        degerli: "Değerli",
        saygin: "Saygın",
        gucsahibi: "Güç Sahibi",
        gururduymus: "Gurur Duymuş",
        guclu: "Güçlü",
        onemli: "Önemli Biri Gibi");
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