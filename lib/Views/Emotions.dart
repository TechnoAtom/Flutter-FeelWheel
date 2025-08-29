import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:duygucarki/Views/Requests.dart'; // BaseUrl için import

class Emotions extends StatefulWidget {
  final int? id;

  const Emotions({Key? key, this.id}) : super(key: key);

  @override
  State<Emotions> createState() => _EmotionsState();
}

class _EmotionsState extends State<Emotions> {
  final DateRangePickerController _datePickerController = DateRangePickerController();
  final DateRangePickerController _controller = DateRangePickerController();

  bool _calendarVisible = false;
  bool _charVisible = true;
  bool _rangeVisibility = false;

  List<Map<String, String>> emotionsList = [];
  List<Map<String, dynamic>> emotionDataForChart = [];

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  late DateTime _startDate, _endDate;

  // ✅ Duygular için sabit liste
  final emotionKeys = ['Kızgın', 'Mutlu', 'Güçlü', 'Üzgün', 'Sakin', 'Korkmuş'];

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();
    _startDate = today;
    _endDate = today.add(Duration(days: 3));

    _datePickerController.displayDate = today;
    _controller.selectedRange = PickerDateRange(_startDate, _endDate);

    selectedStartDate = _startDate;
    selectedEndDate = _endDate;
  }
  @override
  void dispose() {
    _datePickerController.dispose();
    _controller.dispose();
    super.dispose();
  }


  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate ?? args.value.startDate;
      selectedStartDate = _startDate;
      selectedEndDate = _endDate;
    });

    print("Başlangıç: ${DateFormat('dd, MMMM yyyy').format(_startDate)}");
    print("Bitiş: ${DateFormat('dd, MMMM yyyy').format(_endDate)}");
  }

  Future<void> fetchData(String selectedStartDate, String selectedEndDate) async {
    int? userId = widget.id;

    DateTime startDate = DateFormat('yyyy-MM-dd').parse(selectedStartDate).subtract(Duration(days: 1));
    DateTime endDate = DateFormat('yyyy-MM-dd').parse(selectedEndDate);

    String startDateFormatted = DateFormat('yyyy-MM-dd').format(startDate);
    String endDateFormatted = DateFormat('yyyy-MM-dd').format(endDate);

    try {
      final response = await http.get(
        Uri.parse('${Requests.baseUrl}/Account/GetUserEmotions?userId=$userId&startDate=$startDateFormatted&endDate=$endDateFormatted'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        emotionsList.clear();
        for (var item in data) {
          emotionsList.add({
            'emotion1': item['emotion1'],
            'emotion2': item['emotion2'],
            'emotion3': item['emotion3'],
          });
        }
        countEmotions();
      } else if (response.statusCode == 404) {
        showDialogMessage(context, "Uyarı", "Kayıt Bulunamadı.");
        setState(() => _charVisible = false);
      } else {
        print('Veri çekme başarısız oldu. Kod: ${response.statusCode}');
      }
    } catch (e) {
      showDialogMessage(context, "Hata", e.toString());
    }
  }

  // ✅ Duyguları sayan dinamik fonksiyon
  void countEmotions() {
    List<String> allEmotions = [];
    for (var emotion in emotionsList) {
      allEmotions.addAll([
        emotion['emotion1']!,
        emotion['emotion2']!,
        emotion['emotion3']!,
      ]);
    }

    Map<String, int> emotionsCount = {};
    for (var emotion in allEmotions) {
      if (emotion.isEmpty) continue;
      emotionsCount[emotion] = (emotionsCount[emotion] ?? 0) + 1;
    }

    final emotionKeys = ['Kızgın', 'Mutlu', 'Güçlü', 'Üzgün', 'Sakin', 'Korkmuş'];

    emotionDataForChart = emotionKeys.map((key) {
      return {'emotion': key, 'count': emotionsCount[key] ?? 0};
    }).toList();

    // ✅ sadece widget hâlâ ekrandaysa güncelle
    if (mounted) {
      setState(() {});
    }
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
          if (_calendarVisible)
            Center(
              child: Container(
                height: scwidht * 0.90,
                width: scwidht * 0.90,
                child: buildSfDateRangePicker(scwidht, context),
              ),
            ),
          Column(
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    SizedBox(height: scheight * 0.02),
                    const Text('Öncelikle Bir Tarih Aralığı Seçelim'),
                    SizedBox(height: scheight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _calendarVisible = !_calendarVisible;
                          _charVisible = false;
                          _rangeVisibility = !_rangeVisibility;
                        });
                      },
                      child: const Text("Tarih Aralığı Seç"),
                    ),
                    if (_rangeVisibility)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${DateFormat('dd, MMMM yyyy').format(_startDate)} - ${DateFormat('dd, MMMM yyyy').format(_endDate)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
              if (_charVisible)
                Container(
                  height: scwidht * 1.5,
                  child: SfCircularChart(
                    palette: const <Color>[
                      Color(0xFFde8c59), // kızgın
                      Color(0xFF6ba4b8), // mutlu
                      Color(0xFFc8b273), // güçlü
                      Color(0xFFca848a), // üzgün
                      Color(0xFF5c6d93), // sakin
                      Color(0xFF9a9bc1), // korkmuş
                    ],
                    legend: Legend(isVisible: true, isResponsive: true, overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries>[
                      PieSeries<Map<String, dynamic>, String>(
                        dataSource: emotionDataForChart,
                        xValueMapper: (data, _) => data['emotion'],
                        yValueMapper: (data, _) => data['count'] == 0 ? 1 : data['count'],
                        dataLabelMapper: (data, _) => "${data['emotion']}\n${data['count']}",
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
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

          String startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate!);
          String endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate!);

          if (startDate.isNotEmpty && endDate.isNotEmpty) {
            fetchData(startDate, endDate);
          }
          _charVisible = true;
          _rangeVisibility = !_rangeVisibility;
        });
      },
      onCancel: () => setState(() => _calendarVisible = false),
      view: DateRangePickerView.month,
      controller: _datePickerController,
      onSelectionChanged: selectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,

      // 🎨 Renk ayarları (bunlar yoksa default gri gelir)
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

// ✅ Tek fonksiyon ile hata/uyarı dialogları
void showDialogMessage(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tamam"),
        ),
      ],
    ),
  );
}
