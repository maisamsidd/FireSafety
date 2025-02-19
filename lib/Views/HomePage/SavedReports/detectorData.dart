import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/contractor_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetectordataSaved extends StatefulWidget {
  final String customerId;
  final String detectorName;
  const DetectordataSaved(
      {super.key, required this.customerId, required this.detectorName});

  @override
  State<DetectordataSaved> createState() => _DetectordataSavedState();
}

class _DetectordataSavedState extends State<DetectordataSaved> {
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController id3Controller = TextEditingController();
  TextEditingController functionTestController = TextEditingController();
  TextEditingController pushController = TextEditingController();
  TextEditingController systemController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? documentId; // To store the Firestore document ID

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  Future<void> fetchData() async {
    try {
      // Query Firestore using the unique customerId and detectorName
      DocumentSnapshot doc = await firestore
          .collection(widget.customerId)
          .doc(widget.detectorName)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          locationController.text = data["Location"] ?? "";
          typeController.text = data["Type"] ?? "";
          id3Controller.text = data["ID NO"] ?? "";
          functionTestController.text = data["Function test PF"] ?? "";
          pushController.text = data["Push button test"] ?? "";
          systemController.text = data["System silence check"] ?? "";
          dateController.text = data["date_completed"] ?? "";
          if (data["currentDate"] != null) {
            selectedDate = (data["currentDate"] as Timestamp).toDate();
          }
        });
      } else {
        Get.snackbar("Error", "No data found for this customer");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e");
    }
  }

  // Function to update Firestore
  Future<void> updateFirestore(String field, String value) async {
    await firestore
        .collection('customers')
        .doc(widget.customerId)
        .collection('detectors')
        .doc(widget.detectorName)
        .update({field: value});
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        automaticallyImplyLeading: false,
        title: const Text(
          "Customer Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.height * 0.01),
              Text("Location", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: locationController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("Location", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("Type", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: typeController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("Type", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("ID NO", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: id3Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("ID NO", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("Function Test PF",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: functionTestController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("Function test PF", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("Push Button Test",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: pushController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("Push button test", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("System Silence Check",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: systemController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("System silence check", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Text("Date Completed",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: dateController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("date_completed", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Purplebutton(
                ontap: () async {
                  Get.to(() =>
                      ContractordetailsReport(customerId: widget.customerId));
                  Get.snackbar("Success", "Data updated successfully");
                },
                text: "Contractor information",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
