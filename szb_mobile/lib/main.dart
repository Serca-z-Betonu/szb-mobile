import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:szb_mobile/home.dart';
import 'package:szb_mobile/server.dart';

void main() {
  initializeDateFormatting("pl");
  runServer();
  pollAlerts();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(
                colorScheme:
                    const ColorScheme.light(primary: Color(0xff275e59)))
            .copyWith(
                cardTheme: const CardTheme(
                    margin: EdgeInsets.all(8),
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Color(0xff64d5bf)),
                        borderRadius: BorderRadius.all(Radius.circular(5))))),
        home: const Home());
  }
}
