import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import '';
import 'Views/LoginScreen.dart';

void main() async {
  // Hive'ı başlat
  await Hive.initFlutter();
  // Hive kutusunu aç
  await Hive.openBox('credentials');

  // Ekran yönünü portreye kilitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Yukarı portre
    DeviceOrientation.portraitDown, // Aşağı portre
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppLifecycleWatcher(child: Loginscreen()),
    );
  }
}

class AppLifecycleWatcher extends StatefulWidget {
  final Widget child;

  const AppLifecycleWatcher({super.key, required this.child});

  @override
  _AppLifecycleWatcherState createState() => _AppLifecycleWatcherState();
}

class _AppLifecycleWatcherState extends State<AppLifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setState(() {});
    } else if (state == AppLifecycleState.resumed) {
      setState(() {});
    } else if (state == AppLifecycleState.detached) {
      setState(() {});
    } else if (state == AppLifecycleState.hidden) {
      setState(() {});
    } else if (state == AppLifecycleState.inactive) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget
        .child; // The child widget will be wrapped with lifecycle watcher
  }
}
