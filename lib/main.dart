import 'package:flutter/material.dart';
import 'package:wear/wear.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:weartest/display_pressure.dart';
import 'package:weartest/home.dart';

main() {
  runApp(BarometerApp());
}

class BarometerApp extends StatelessWidget {
  const BarometerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}
