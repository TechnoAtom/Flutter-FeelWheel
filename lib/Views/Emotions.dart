import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat sınıfını import ediyoruz
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // Syncfusion datepicker'ı import ediyoruz
import 'dart:convert';
import 'package:http/http.dart' as http;

class Emotions extends StatefulWidget {
  final int? id;

  const Emotions({Key? key, this.id}) : super(key: key);

  @override
  State<Emotions> createState() => _EmotionsState();
}

class _EmotionsState extends State<Emotions> {
  DateRangePickerController _datePickerController = DateRangePickerController();
  bool _calendarVisible = false;
  bool _charVisible = true;
  bool _rangeVisibility = false;
  String _range = '';
  List<String> chartEmotions= [];
  List<int> emotionCounts = [];  // Duyguların sayısını tutacak liste




  List<Map<String, String>> emotionsList = [];

  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  late DateTime _startDate, _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    // Başlangıç tarihlerini belirliyoruz (bugün ve 3 gün sonrası)
    _datePickerController.displayDate = DateTime.now();
    final DateTime today = DateTime.now();
    _startDate = today;
    _endDate = today.add(Duration(days: 3));
    _controller.selectedRange = PickerDateRange(today, today.add(Duration(days: 3)));

    // Seçilen tarihleri başlatıyoruz
    selectedStartDate = today;
    selectedEndDate = today.add(Duration(days: 3));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      // Tarih seçildiğinde
      _startDate = args.value.startDate;
      _endDate = args.value.endDate ?? args.value.startDate; // Eğer endDate null ise, startDate kullanılıyor
      selectedStartDate = _startDate;
      selectedEndDate = _endDate;
    });

    // Tarih formatını ekrana yazdırıyoruz
    String formattedStartDate = DateFormat('dd, MMMM yyyy').format(_startDate);
    String formattedEndDate = DateFormat('dd, MMMM yyyy').format(_endDate);

    print("Başlangıç Tarihi: $formattedStartDate");
    print("Bitiş Tarihi: $formattedEndDate");
  }

  Future<void> fetchData(String selectedStartDate, String selectedEndDate) async {
    int? userId = widget.id; // Kullanıcı ID'si isteğe bağlı

    // Tarihlerin bir gün öncesine ayarlandığından emin olalım
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(selectedStartDate).subtract(Duration(days: 1));
    DateTime endDate = DateFormat('yyyy-MM-dd').parse(selectedEndDate);

    String startDateFormatted = DateFormat('yyyy-MM-dd').format(startDate); // Başlangıç tarihi bir gün önce
    String endDateFormatted = DateFormat('yyyy-MM-dd').format(endDate); // Bitiş tarihi değişmeden

    try {
      // API'ye tarih aralığını ve kullanıcı ID'sini gönderiyoruz
      final response = await http.get(
        Uri.parse(
            'https://apronmobil.com/Account/GetUserEmotions?userId=$userId&startDate=$startDateFormatted&endDate=$endDateFormatted'),
      );

      if (response.statusCode == 200) {
        // API'den gelen veriyi işleme
        var data = json.decode(response.body);

        // Yeni listeyi oluşturuyoruz
        emotionsList.clear();  // Eski veriyi temizleyelim
        for (var item in data) {
          Map<String, String> emotionData = {
            'emotion1': item['emotion1'],
            'emotion2': item['emotion2'],
            'emotion3': item['emotion3'],
          };
          emotionsList.add(emotionData);
        }
        print(emotionsList.toString());

        // Duyguları sayma işlemi
        countEmotions();
      } else {
        if(response.statusCode == 404){
          showNotFound(context, response.statusCode.toString());
          setState(() {
            _charVisible=false;
          });
        }
        print('Veri çekme başarısız oldu. Durum Kodu: ${response.statusCode}');
      }
    } catch (e) {
      showCustomDialog(context, e.toString());
      print('Hata: $e');
    }
  }


  /* void countEmotions() {
    List<String> allEmotions = [];
    for (var emotion in emotionsList) {
      allEmotions.add(emotion['emotion1']!);
      allEmotions.add(emotion['emotion2']!);
      allEmotions.add(emotion['emotion3']!);
    }

    Map<String, int> emotionsCount = {};
    for (var emotion in allEmotions) {
      if (emotionsCount.containsKey(emotion)) {
        emotionsCount[emotion] = emotionsCount[emotion]! + 1;
      } else {
        emotionsCount[emotion] = 1;
      }
    }

    // Her bir duygunun sayısını değişkene atayabiliriz:
    int angerCount = emotionsCount['Kizgin'] ?? 0;
    int happyCount = emotionsCount['Kizgin'] ?? 0;
    int strongCount = emotionsCount['Kizgin'] ?? 0;
    int sadCount = emotionsCount['Kizgin'] ?? 0;
    int calmCount = emotionsCount['Sakin'] ?? 0;
    int scaredCount = emotionsCount['Kizgin'] ?? 0;



    /*
    int frustrationCount = emotionsCount['Rahatsiz Edilmis'] ?? 0;
    int aggressionCount = emotionsCount['Agresif'] ?? 0;
    int dusmanca = emotionsCount['Düsmanca'] ?? 0;
    int igrenmis = emotionsCount['Igrenmis'] ?? 0;

     */

    emotionCounts.add(angerCount);   // angerCount'ı ekle
    emotionCounts.add(happyCount);   // angerCount'ı ekle
    emotionCounts.add(strongCount);   // angerCount'ı ekle
    emotionCounts.add(sadCount);   // angerCount'ı ekle
    emotionCounts.add(calmCount);   // angerCount'ı ekle
    emotionCounts.add(scaredCount);   // angerCount'ı ekle


    for (var emotion in emotionsList) {
      // emotion1 değeri "Kızgın" olduğunda ekle
      if (emotion['emotion1'] == 'Kizgin') {
        chartEmotions.add(emotion['emotion1']!);
      }
    }
    print('cabirssiker = ${chartEmotions.toString()} ' );



    // Örneğin, ekranda yazdırabiliriz:
    print("Kizgin Sayısı: $angerCount");


  }
*/

  void countEmotions() {
    List<String> allEmotions = [];
    for (var emotion in emotionsList) {
      allEmotions.add(emotion['emotion1']!);
      allEmotions.add(emotion['emotion2']!);
      allEmotions.add(emotion['emotion3']!);
    }

    // Duyguların sayısını tutmak için bir Map
    Map<String, int> emotionsCount = {};
    for (var emotion in allEmotions) {
      if (emotionsCount.containsKey(emotion)) {
        emotionsCount[emotion] = emotionsCount[emotion]! + 1;
      } else {
        emotionsCount[emotion] = 1;
      }
    }

    // Duyguların sayısını almak
    int angryCount = emotionsCount['Kizgin'] ?? 0;
    int happyCount = emotionsCount['Mutlu'] ?? 0;
    int strongCount = emotionsCount['Güçlü'] ?? 0;
    int sadCount = emotionsCount['Üzgün'] ?? 0;
    int calmCount = emotionsCount['Sakin'] ?? 0;
    int scaredCount = emotionsCount['Korkmus'] ?? 0;

    // emotionDataForChart listesine verileri eklemek
    emotionDataForChart = [
      {'emotion': 'Kizgin', 'count': angryCount == 0 ? 0 : angryCount},
      {'emotion': 'Mutlu', 'count': happyCount == 0 ? 0 : happyCount},
      {'emotion': 'Güçlü', 'count': strongCount == 0 ? 0 : strongCount},
      {'emotion': 'Üzgün', 'count': sadCount == 0 ? 0 : sadCount},
      {'emotion': 'Sakin', 'count': calmCount == 0 ? 0 : calmCount},
      {'emotion': 'Korkmus', 'count': scaredCount == 0 ?  0 : scaredCount},
    ];


    // Veriyi ekranda yazdırma (isteğe bağlı)
    print("Kızgın Count: $angryCount");
    print("Happy Count: $happyCount");
    print("Strong Count: $strongCount");
    print("Sad Count: $sadCount");
    print("Calm Count: $calmCount");
    print("Scared Count: $scaredCount");
    setState(() {

    });
  }


  List<Map<String, dynamic>> emotionDataForChart = [
    /* {'emotion': 'Korkmuş', 'count': 7 , 'label':'Kızgın'},
    {'emotion': 'Kızgın', 'count':6 ,'label':'Mutlu'},
    {'emotion': 'Güçlü', 'count': 5,'label':'Güçlü'},
    {'emotion': 'Mutlu', 'count': 4,'label':'Üzgün'},
    {'emotion': 'Sakin', 'count': 3,'label':'Sakin'},
    {'emotion': 'Üzgün', 'count': 5,'label':'Korkmuş'},*/
  ];

  // Duyguları ekrana yazdırma
  void displayEmotionCounts(Map<String, int> emotionsCount) {
    print("Duygu Sayıları:");
    emotionsCount.forEach((emotion, count) {
      print('$emotion: $count');
    });
  }

  @override
  Widget build(BuildContext context) {
    var scsize = MediaQuery.of(context);
    double scwidht = scsize.size.width;
    double scheight = scsize.size.height;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC98A8F),
        title: const Text(
          'Duygularım',
          style: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontSize: 28,
            fontWeight: FontWeight.w100,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: _calendarVisible,
            child: Center(
              child: Container(
                height: scwidht * 0.90,
                width: scwidht * 0.90,
                child: buildSfDateRangePicker(scwidht, context),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Center(
                child: Container(child:
                Column(
                  children: [
                    SizedBox(height: scheight* 0.02,),
                    Text('Öncelikle Bir Tarih Aralığı Seçelim'),
                    SizedBox(height: scheight * 0.02,),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _calendarVisible = !_calendarVisible;
                          _charVisible = false;
                          _rangeVisibility = !_rangeVisibility;
                        });
                      },
                      child: Text("Tarih Aralığı Seç"),
                    ),
                    Visibility(visible: _rangeVisibility,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${DateFormat('dd, MMMM yyyy').format(_startDate)} - ${DateFormat('dd, MMMM yyyy').format(_endDate)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),

              Visibility(
                visible:_charVisible,
                child: Container(
                  height: scwidht * 1.5,
                  child: SfCircularChart(
                    // Palette (renk paleti) tanımlandı
                    palette: const <Color>[
                      Color(0xFFde8c59),// kızgın
                      Color(0xFF6ba4b8),// mutlu
                      Color(0xFFc8b273), // güçlü
                      Color(0xFFca848a), // üzgün
                      Color(0xFF5c6d93), // sakin
                      Color(0xFF9a9bc1),// korkmuş

                      // 6. dilim rengi
                      // 5. dilim rengi
                    ],

                    //custom emoji for legend
                    /* legend: Legend(
                        isVisible: true,
                        // Templating the legend item
                        legendItemBuilder:
                            (String name, dynamic series, dynamic point, int index) {
                          return Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                child: Container(
                                    child: Image.asset('assets/images/happy.png')),
                              ),
                              Text(point.y.toString()),
                            ],
                          );
                        }),*/
                    legend: Legend(isVisible: true , isResponsive: true,overflowMode: LegendItemOverflowMode.wrap),
                    // Tooltip (bilgi balonu) görünür
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries>[
                      PieSeries<Map<String, dynamic>, String>(
                        dataSource: emotionDataForChart,
                        xValueMapper: (data, _) => data['emotion'],
                        // X verisi
                        yValueMapper: (data, _) => data['count'] == 0 ? 1 :data['count'],
                        // Y verisi
                        dataLabelMapper: (data, _) => data['emotion']+"\n"+(data['count'].toString()),
                        // Veriyi etiketle
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontSize: 14, color: Colors.white),
                        ), // Etiketleri göster
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SfDateRangePicker buildSfDateRangePicker(double scwidht, BuildContext context) {
    return SfDateRangePicker(
      showActionButtons: true,
      onSubmit: (value) {
        setState(() {
          _calendarVisible = !_calendarVisible;

          String startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate);
          String endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);

          // Tarihler geçerliyse, 1 gün öncesine ayarla
          if (startDate.isNotEmpty && endDate.isNotEmpty) {
            fetchData(startDate, endDate);  // Veriyi çağır
          } else {
            print('Tarihler geçerli değil!');
          }

          _charVisible = true;
          _rangeVisibility = !_rangeVisibility;
        });
      },
      onCancel: () {
        setState(() {
          _calendarVisible = false;
        });
      },
      view: DateRangePickerView.month,
      selectionTextStyle: const TextStyle(color: Colors.black),
      selectionColor: Colors.blue,
      startRangeSelectionColor: Color(0xFFF2F2D9),
      endRangeSelectionColor: Color(0xFFF2F2D9),
      rangeSelectionColor: Color(0xFFAEBD94),
      rangeTextStyle: TextStyle(color: Colors.white, fontSize: scwidht * 0.045),
      headerHeight: scwidht * 0.20,
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: Color(0xFFC98A8F),
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontSize: scwidht * 0.075,
          letterSpacing: 3,
          color: Color(0xFFF2F2D9),
        ),
      ),
      monthViewSettings: DateRangePickerMonthViewSettings(
        dayFormat: 'EEE',
        showTrailingAndLeadingDates: true,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          backgroundColor: Color(0xFFDEC2BD),
          textStyle: TextStyle(
            fontSize: scwidht * 0.035,
            letterSpacing: 2,
            color: Color(0xFFFFFFF2),
          ),
        ),
      ),
      showNavigationArrow: true,
      controller: _datePickerController,
      onSelectionChanged: selectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      yearCellStyle: DateRangePickerYearCellStyle(
        disabledDatesDecoration: BoxDecoration(
          color: const Color(0xFFDFDFDF),
          border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
          shape: BoxShape.circle,
        ),
        disabledDatesTextStyle: const TextStyle(color: Colors.black),
        leadingDatesTextStyle: const TextStyle(color: Colors.black),
        textStyle: const TextStyle(color: Colors.blue),
        todayCellDecoration: BoxDecoration(
          color: const Color(0xFFFFFFF2),
          border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Color(0xFFC98A8F)),
      ),
    );
  }
}

// Dialog fonksiyonunu burada tanımlıyoruz
void showCustomDialog(BuildContext context, String oe) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: const Text(
                'Tamam',
                style: TextStyle(
                  fontFamily: 'Barlow Condensed',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
      title: const Text('Uyarı'),
      contentPadding: const EdgeInsets.all(20),
      content: Text(
        'Hata : ${oe}',
        style: const TextStyle(
          fontFamily: 'Barlow Condensed',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w200,
          fontSize: 18,
        ),
      ),
    ),
  );
}

// Dialog fonksiyonunu burada tanımlıyoruz
void showNotFound(BuildContext context, String oe) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: const Text(
                'Tamam',
                style: TextStyle(
                  fontFamily: 'Barlow Condensed',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
      title: const Text('Uyarı'),
      contentPadding: const EdgeInsets.all(20),
      content: Text(
        'Kayıt Bulunamadı.',
        style: const TextStyle(
          fontFamily: 'Barlow Condensed',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w200,
          fontSize: 18,
        ),
      ),
    ),
  );
}


