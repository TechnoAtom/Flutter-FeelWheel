class Happymodel {
  final String mutlu;

  final String neseli;

  final String keyifli;

  final String zevkalmis;

  final String sevinmis;
  final String eglenmis;

  final String nesesacan;

  final String memnun;

  final String cokeglenmis;

  final String hevesli;

  final String hosnutolmus;

  final String heyecanli;

  final String tutkulu;

  bool _isVisible1 = false;
  bool _isVisible2 = false;

  Happymodel({
    required this.mutlu,
    required this.neseli,
    required this.keyifli,
    required this.zevkalmis,
    required this.sevinmis,
    required this.eglenmis,
    required this.nesesacan,
    required this.memnun,
    required this.cokeglenmis,
    required this.hevesli,
    required this.hosnutolmus,
    required this.heyecanli,
    required this.tutkulu
  });

  factory Happymodel.defaultValues() {
    return Happymodel(mutlu: "Mutlu",
        neseli: "Neşeli",
        keyifli: "Keyifli",
        zevkalmis: "Zevk Almış",
        sevinmis: "Sevinmiş",
        eglenmis: "Eğlenmiş",
        nesesacan: "Neşe Saçan",
        memnun: "Memnun",
        cokeglenmis: "Çok Eğlenmiş",
        hevesli: "Hevesli",
        hosnutolmus: "Hoşnut Olmuş",
        heyecanli: "Heyecanlı",
        tutkulu: "Tutkulu");
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