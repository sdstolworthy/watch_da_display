import 'package:flutter/material.dart';

class SelectAltimeterSetting extends StatefulWidget {
  @override
  _SelectAltimeterSettingState createState() => _SelectAltimeterSettingState();
}

class _SelectAltimeterSettingState extends State<SelectAltimeterSetting> {
  static const int minWhole = 25;
  static const initialWholeIndex = 4;
  static const initialDecimalIndex = 92;
  int selectedWholeIndex = initialWholeIndex;
  int selectedDecimalIndex = initialDecimalIndex;
  final wholeScrollController =
      FixedExtentScrollController(initialItem: initialWholeIndex);
  final decimalScrollController =
      FixedExtentScrollController(initialItem: initialDecimalIndex);
  double get selectedAltimeterSetting => double.parse(
      '${wholeScrollController.selectedItem + minWhole}.${decimalScrollController.selectedItem}');
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ListWheelScrollView(
                            controller: wholeScrollController,
                            itemExtent: 50,
                            useMagnifier: true,
                            magnification: 1.5,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedWholeIndex = index;
                              });
                            },
                            children: List.generate(
                                10,
                                (index) => Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: index == selectedWholeIndex
                                                ? EdgeInsets.only(right: 20)
                                                : EdgeInsets.zero,
                                            child: Text(
                                              '${index + minWhole}',
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                      ),
                      const Text('.'),
                      Expanded(
                        child: ListWheelScrollView(
                            controller: decimalScrollController,
                            itemExtent: 35,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedDecimalIndex = index;
                              });
                            },
                            useMagnifier: true,
                            magnification: 1.5,
                            children: List.generate(
                                100,
                                (index) => Row(
                                      children: [
                                        Padding(
                                          padding: index == selectedDecimalIndex
                                              ? EdgeInsets.only(left: 20)
                                              : EdgeInsets.zero,
                                          child: Text(
                                            '${index.toString().padLeft(2, '0')}',
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ))),
                      ),
                    ],
                  ),
                ),
                const Text('in. Hg')
              ],
            ),
          ),
          Center(
              child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedAltimeterSetting);
            },
          ))
        ],
      ),
    );
  }
}
