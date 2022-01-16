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

  String get localAltimeterSettingReading {
    if (selectedAltimeterSetting == null) {
      return 'Not set';
    }
    return '${selectedAltimeterSetting!.toStringAsFixed(2)} inHg';
  }

  String get oatReading {
    if (selectedOAT == null) {
      return 'Not set';
    }
    return '$selectedOAT°C';
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(builder: (context, wearShape, child) {
      return Material(
        color: Colors.black,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final double result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        SelectAltimeterSetting()));
                            setState(() {
                              selectedAltimeterSetting = result;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Local Altimeter Setting',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  localAltimeterSettingReading,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final int result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SelectOAT()));
                            setState(() {
                              selectedOAT = result;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OAT',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  oatReading,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Flexible(
                      child: AltitudeReadings(
                          barometerStream: barometerStream,
                          selectedOAT: selectedOAT,
                          selectedAltimeterSetting: selectedAltimeterSetting)),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

class AltitudeReadings extends StatelessWidget {
  const AltitudeReadings({
    Key? key,
    required this.barometerStream,
    required this.selectedAltimeterSetting,
    required this.selectedOAT,
  }) : super(key: key);

  final Stream<BarometerValue>? barometerStream;
  final double? selectedAltimeterSetting;
  final int? selectedOAT;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarometerValue>(
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
                ),
              Center(
                  child: Text(
                'Density Altitude',
                style: TextStyle(color: Colors.white),
              )),
              Text(
                getDensityAltitudeText(
                  selectedOAT,
                  selectedAltimeterSetting,
                  snapshot.data!.inchOfMercury,
                ),
                style: TextStyle(color: Colors.white),
              ),
              Center(
                  child: Text(
                'Pressure Altitude',
                style: TextStyle(color: Colors.white),
              )),
              Text(
                '${getPressureAltitude(snapshot.data!.inchOfMercury).round()} ft',
                style: TextStyle(color: Colors.white),
              ),
            ],
          );
        });
  }
}

double getCurrentAltitudeInFeet(
    double altimeterSetting, double barometerReading) {
  return (altimeterSetting - barometerReading) * 1000;
}

double getISA(double currentAltitudeInFeet) {
  final isaDifference = (currentAltitudeInFeet / 1000) * 1.98;
  return 15 - isaDifference;
}

double getDensityAltitude(int oat, double currentAltitudeInFeet) {
  final isa = getISA(currentAltitudeInFeet);
  final densityAltitude = currentAltitudeInFeet + (120 * (oat - isa));
  return densityAltitude;
}

double getPressureAltitude(double ambientPressure) {
  final difference = 29.92 - ambientPressure;
  return difference * 1000;
}

String getDensityAltitudeText(
    int? selectedOAT, double? selectedAltimeterSetting, double? pressure) {
  if (selectedOAT == null) {
    return 'OAT not selected';
  }
  if (selectedAltimeterSetting == null) {
    return 'Select Altimeter Setting';
  }
  if (pressure == null) {
    return 'Pressure not available';
  }
  final altitude = getCurrentAltitudeInFeet(selectedAltimeterSetting, pressure);
  final densityAltitude = getDensityAltitude(selectedOAT, altitude);
  return '${densityAltitude.round()} ft';
}
