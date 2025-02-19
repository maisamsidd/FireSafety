import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/contractor_details.dart';
import 'package:fire_safety_suffolk/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDataSaved extends StatefulWidget {
  final String customerId;
  const CustomerDataSaved({super.key, required this.customerId});

  @override
  State<CustomerDataSaved> createState() => _CustomerDataSavedState();
}

class _CustomerDataSavedState extends State<CustomerDataSaved> {
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController address3Controller = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController serielController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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
      // Query Firestore using the unique customerId
      QuerySnapshot snapshot = await firestore
          .collection("data")
          .where("customerId", isEqualTo: widget.customerId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the first document (assuming customerId is unique)
        var doc = snapshot.docs.first;
        documentId = doc.id; // Store the document ID for updates
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data["customerName"] ?? "";
          address1Controller.text = data["customerAddress1"] ?? "";
          address2Controller.text = data["customerAddress2"] ?? "";
          address3Controller.text = data["customerAddress3"] ?? "";
          postalCodeController.text = data["customerPostal_code"] ?? "";
          serielController.text = data["customerSerial"] ?? "";
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
    if (documentId != null) {
      await firestore.collection("data").doc(documentId).update({field: value});
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
              Text("Expiry date", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.04),
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
                            // Update Firestore with the new date
                            if (documentId != null) {
                              firestore
                                  .collection("data")
                                  .doc(documentId)
                                  .update({"currentDate": newDate});
                            }
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              SizedBox(height: mq.height * 0.04),
              Text("Certificate Serial No./Ref.",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: serielController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerSerial", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.03),
              SizedBox(height: mq.height * 0.01),
              Text("Name", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerName", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              Container(
                width: mq.width * 0.22,
                height: mq.height * 0.07,
                decoration: BoxDecoration(
                    color: MyColors.redColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Address",
                        style: TextStyle(color: MyColors.whiteColor)),
                  ),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: address1Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Address 1", border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerAddress1", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: address2Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Address 2", border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerAddress2", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: address3Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Address 3", border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerAddress3", value);
                  },
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: postalCodeController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Postal code", border: OutlineInputBorder()),
                  onChanged: (value) {
                    updateFirestore("customerPostal_code", value);
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
