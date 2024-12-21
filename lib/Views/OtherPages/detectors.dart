import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomScrollOptionButton extends StatefulWidget {
  final List<String> options;
  final double width;
  final TextStyle textStyle;
  final Function(String) onValueSelected;

  const CustomScrollOptionButton({
    super.key,
    required this.options,
    required this.onValueSelected,
    this.width = 370,
    this.textStyle = const TextStyle(),
  });

  @override
  State<CustomScrollOptionButton> createState() =>
      _CustomScrollOptionButtonState();
}

class _CustomScrollOptionButtonState extends State<CustomScrollOptionButton> {
  bool isOpen = false;
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options.first; // Default to the first option
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: MyColors.blackColor,
                  border: Border.all(color: MyColors.whiteColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedOption, style: widget.textStyle),
                      Icon(
                        Icons.arrow_drop_down,
                        color: MyColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isOpen)
            SizedBox(
              height: 200, // Adjust the height as needed
              child: ListView(
                children: widget.options
                    .map((option) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedOption = option;
                                isOpen = false;
                              });
                              widget.onValueSelected(selectedOption);
                            },
                            child: Container(
                              width: widget.width,
                              color: MyColors.blackColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(option, style: widget.textStyle),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class Detectors extends StatefulWidget {
  const Detectors({super.key});

  @override
  State<Detectors> createState() => _DetectorsState();
}

class _DetectorsState extends State<Detectors> {
  DateTime selectedDate = DateTime.now();
  final Map<String, String> selectedValues = {};

  Future<void> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('detectors').add({
        'Location': selectedValues['Location'] ?? 'N/A',
        'Type': selectedValues['Type'] ?? 'N/A',
        'ID NO': selectedValues['ID NO'] ?? 'N/A',
        'Function test P/F': selectedValues['Function test P/F'] ?? 'N/A',
        'Push button test': selectedValues['Push button test'] ?? 'N/A',
        'System silence check': selectedValues['System silence check'] ?? 'N/A',
        'Exp date': selectedDate.toIso8601String(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
      ),
      backgroundColor: MyColors.blackColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: mq.height * 0.1,
              color: MyColors.redColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Save",
                    style: TextStyle(color: MyColors.whiteColor, fontSize: 24),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: mq.height * 0.1,
              color: MyColors.greYColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Detectors",
                        style:
                            TextStyle(color: MyColors.whiteColor, fontSize: 24),
                      ),
                      SizedBox(
                        width: mq.width * 0.3,
                      ),
                      Purplebutton(
                        text: "Add to database",
                        ontap: saveToFirestore,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Location",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["Pass", "Fail", "N/A", "None"],
                    onValueSelected: (selectedValue) {
                      selectedValues['Location'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Type",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["A", "B", "C", "D"],
                    onValueSelected: (selectedValue) {
                      selectedValues['Type'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ID NO :",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["A", "B", "C", "D"],
                    onValueSelected: (selectedValue) {
                      selectedValues['ID NO'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Function test P/F",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["A", "B", "C", "D"],
                    onValueSelected: (selectedValue) {
                      selectedValues['Function test P/F'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Push button test",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["A", "B", "C", "D"],
                    onValueSelected: (selectedValue) {
                      selectedValues['Push button test'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "System silence check",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["A", "B", "C", "D"],
                    onValueSelected: (selectedValue) {
                      selectedValues['System silence check'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Exp date",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: mq.height * 0.4,
                            color: MyColors.greYColor,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: selectedDate,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  selectedDate = newDate;
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: MyColors.greYColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                              color: MyColors.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: MyColors.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
