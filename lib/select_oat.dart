// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SelectOAT extends StatefulWidget {
  @override
  State<SelectOAT> createState() => _SelectOATState();
}

class _SelectOATState extends State<SelectOAT> {
  final controller = FixedExtentScrollController(initialItem: initialItem);
  int selectedIndex = initialItem;
  static const initialItem = 80;
  static const tempOptionsCount = 120;
  static const startingTemperature = -50;

  int getTemperatureFromIndex(int index) {
    return startingTemperature + index;
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListWheelScrollView(
                    useMagnifier: true,
                    magnification: 1.5,
                    onSelectedItemChanged: (item) {
                      setState(() {
                        selectedIndex = item;
                      });
                    },
                    children: List.generate(
                      tempOptionsCount,
                      (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: selectedIndex == index
                                  ? const EdgeInsets.only(right: 20)
                                  : EdgeInsets.zero,
                              child: Text(
                                getTemperatureFromIndex(index).toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    itemExtent: 50,
                    controller: controller,
                    physics: FixedExtentScrollPhysics(),
                  ),
                ),
                Expanded(
                  child: Text('°C'),
                )
              ],
            ),
          ),
          Center(
              child: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, getTemperatureFromIndex(selectedIndex));
            },
          ))
        ],
      );
    }));
  }
}
