// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:wear/wear.dart';
import 'package:weartest/select_alt_setting.dart';
import 'package:weartest/select_oat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? selectedAltimeterSetting;
  int? selectedOAT;
  Stream<BarometerValue>? barometerStream;
  double? pressure;

  @override
  void initState() {
    barometerStream = FlutterBarometer.currentPressureEvent
      ..listen((event) {
        setState(() {
          pressure = event.inchOfMercury;
        });
      });
    super.initState();
  }

  double getCurrentAltitudeInFeet(
      double altimeterSetting, double barometerReading) {
    return (altimeterSetting - barometerReading) * 1000;
  }

  double getISA(double currentAltitudeInFeet) {
    final isaDifference = (currentAltitudeInFeet / 1000) * 1.98;
    return 15 - isaDifference;
  }

  double? getDensityAltitude(int oat, double currentAltitudeInFeet) {
    final isa = getISA(currentAltitudeInFeet);
    final densityAltitude = currentAltitudeInFeet + (120 * (oat - isa));
    return densityAltitude;
  }

  String get densityAltitudeText {
    if (selectedOAT == null) {
      return 'OAT not selected';
    }
    if (selectedAltimeterSetting == null) {
      return 'Select Altimeter Setting';
    }
    if (pressure == null) {
      return 'Pressure not available';
    }
    final altitude =
        getCurrentAltitudeInFeet(selectedAltimeterSetting!, pressure!);
    final densityAltitude = getDensityAltitude(selectedOAT!, altitude);
    return '${densityAltitude?.round()} ft';
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(builder: (context, wearShape, child) {
      return Material(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        final double result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SelectAltimeterSetting()));
                        setState(() {
                          selectedAltimeterSetting = result;
                        });
                      },
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 100,
                            maxHeight: 100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Local Altimeter Setting',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                selectedAltimeterSetting.toString(),
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        final int result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SelectOAT()));
                        setState(() {
                          selectedOAT = result;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OAT',
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '$selectedOAT°C',
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: StreamBuilder<BarometerValue>(
                    stream: barometerStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text(
                            'No Barometer Data',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Center(
                              child: Text(
                            'Density Altitude',
                            style: TextStyle(color: Colors.white),
                          )),
                          Text(
                            densityAltitudeText,
                            style: TextStyle(color: Colors.white),
                          ),
                          Center(
                              child: Text(
                            'Current Altitude MSL',
                            style: TextStyle(color: Colors.white),
                          )),
                          if (selectedAltimeterSetting == null)
                            Text(
                              'Select altimeter setting',
                              style: TextStyle(color: Colors.white),
                            )
                          else
                            Text(
                              '${getCurrentAltitudeInFeet(selectedAltimeterSetting!, snapshot.data!.inchOfMercury).round()} ft',
                              style: TextStyle(color: Colors.white),
                            )
                        ],
                      );
                    })),
          ],
        ),
      );
    });
  }
}
