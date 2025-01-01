
class CalmModel {
  final String sakin;

  //second
  final String rahatlamis;
  final String yumusamis;

  final String guvende;

  final String odaklanmis;

  final String aktif;

  final String konforda;

  //third
  final String bariscil;

  final String rahatlikicinde;

  final String duygusal;

  final String halindenmenun;

  final String iyimser;

  final String kabullenmis;

  bool _isVisible1 = false;
  bool _isVisible2 = false;

  CalmModel({
    required this.sakin,
    required this.rahatlamis,
    required this.yumusamis,
    required this.guvende,
    required this.odaklanmis,
    required this.aktif,
    required this.konforda,
    required this.bariscil,
    required this.rahatlikicinde,
    required this.duygusal,
    required this.halindenmenun,
    required this.iyimser,
    required this.kabullenmis
  });

  factory CalmModel.defaultValues() {
    return CalmModel(
        sakin: "Sakin",
        rahatlamis: "Rahatlamış",
        yumusamis: "Yumuşamış",
        guvende: "Güvende",
        odaklanmis: "Odaklanmış",
        aktif: "Aktif",
        konforda:"Konforda",
        bariscil: "Barışcıl",
        rahatlikicinde: "Rahatlık İçinde",
        duygusal: "Duygusal",
        halindenmenun: "Halinden Memnun",
        iyimser: "iyimser",
        kabullenmis: "Kabullenmiş");
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


