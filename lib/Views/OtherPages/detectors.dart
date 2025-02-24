import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/Apis/apis.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/Saved_reports.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/Add_detectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

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
              child: Align(
                alignment: Alignment.centerLeft,
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
  final docName;
  final detectorId;
  final detectorName;
  const Detectors(
      {super.key, this.docName, this.detectorName, this.detectorId});

  @override
  State<Detectors> createState() => _DetectorsState();
}

class _DetectorsState extends State<Detectors> {
  DateTime selectedDate = DateTime.now();
  final Map<String, String> selectedValues = {};

  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    Future<void> saveToFirestore() async {
      try {
        // Validation checks for required fields
        if (locationController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location is required')),
          );
          return;
        }
        if (selectedValues['Type'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Type is required')),
          );
          return;
        }
        if (idController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID NO is required')),
          );
          return;
        }
        if (selectedValues['Function test PF'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Function test PF is required')),
          );
          return;
        }
        if (selectedValues['Push button test'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Push button test is required')),
          );
          return;
        }
        if (selectedValues['System silence check'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('System silence check is required')),
          );
          return;
        }

        // Format the date to "Month Year" (e.g., "October 2025")
        String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

        // Save data to Firestore
        await fireStore
            .collection(widget.docName)
            .doc(widget.detectorName)
            .collection("detectorData")
            .add({
          'Location': locationController.text.trim(),
          'Type': selectedValues['Type']!,
          'ID NO': idController.text.trim(),
          'Function test PF': selectedValues['Function test PF']!,
          'Push button test': selectedValues['Push button test']!,
          'System silence check': selectedValues['System silence check']!,
          'date_completed': formattedDate,
        });

        Get.to(() => AddDetectors(docName: widget.docName));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );

        // Clear the fields after successful submission
        locationController.clear();
        idController.clear();
        setState(() {
          selectedValues.clear();
          selectedDate = DateTime.now();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }

    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SavedReports()));
                    },
                    child: Text(
                      "Check the report",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 24),
                    ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: locationController,
                          style: TextStyle(color: MyColors.whiteColor),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
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
                    options: const [
                      "Smoke",
                      "Heat",
                      "Call point",
                      "CO",
                      "Other"
                    ],
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: idController,
                          style: TextStyle(color: MyColors.whiteColor),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Function test PF",
                      style:
                          TextStyle(color: MyColors.whiteColor, fontSize: 16),
                    ),
                  ),
                  CustomScrollOptionButton(
                    options: const ["Pass", "Fail", "N/A", "None"],
                    onValueSelected: (selectedValue) {
                      selectedValues['Function test PF'] = selectedValue;
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
                    options: const ["Pass", "Fail", "N/A", "None"],
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
                    options: const ["Pass", "Fail", "N/A", "None"],
                    onValueSelected: (selectedValue) {
                      selectedValues['System silence check'] = selectedValue;
                    },
                    textStyle:
                        TextStyle(color: MyColors.whiteColor, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Date completed",
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
      bottomNavigationBar: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => AddDetectors(docName: widget.docName),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.greenColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: mq.width * 0.15,
              height: mq.height * 0.05,
              child: Center(
                child: Text("Back"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
