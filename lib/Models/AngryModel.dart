
class AngryModel {
  final String kizgin;

  //second
  final String ofkeli;
  final String rahatsizedilmis;
  final String caniacimis;
  final String nefretdolu;
  final String huysuz;
  final String kiskanc;

  //third
  final String husranaugramis;
  final String agirlikcokmus;
  final String igrenmis;
  final String agresif;
  final String dusmanca;
  final String rahatsizlikduymus;

  bool _isVisible1 = false;
  bool _isVisible2 = false;

  AngryModel({
    required this.kizgin,
    required this.ofkeli,
    required this.rahatsizedilmis,
    required this.caniacimis,
    required this.nefretdolu,
    required this.huysuz,
    required this.kiskanc,
    required this.husranaugramis,
    required this.agirlikcokmus,
    required this.igrenmis,
    required this.agresif,
    required this.dusmanca,
    required this.rahatsizlikduymus,
  });

  factory AngryModel.defaultValues() {
    return AngryModel(
        kizgin: "Kızgın",
        ofkeli: "Öfkeli",
        rahatsizedilmis: "Rahatsız Edilmiş",
        caniacimis: "Canı Acımış",
        nefretdolu: "Nefret Dolu",
        huysuz: "Huysuz",
        kiskanc: "Kıskanç",
        husranaugramis:  "Hüsrana Uğramış",
        agirlikcokmus: "Ağırlık Çökmüş",
        igrenmis: "İğrenmiş",
        agresif: "Agresif",
        dusmanca: "Düşmanca",
        rahatsizlikduymus: "Rahatsızlık Duymuş");
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