import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/ContractorDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Utils/AppColors.dart';
import '../../main.dart';

class Customerdetails extends StatefulWidget {
  const Customerdetails({super.key});

  @override
  State<Customerdetails> createState() => _CustomerdetailsState();
}

class _CustomerdetailsState extends State<Customerdetails> {
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController address3Controller = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController serielController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
        title: Text("Details of Customers",
            style: TextStyle(color: MyColors.whiteColor)),
        centerTitle: true,
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
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Purplebutton(
                ontap: () async {},
                text: "Save",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          InkWell(
            onTap: () async {
              String customerId =
                  DateTime.now().millisecondsSinceEpoch.toString();

              await fireStore.collection("data").add({
                "customerId": customerId,
                "customerSerial": serielController.text,
                "customerName": nameController.text,
                "customerAddress1": address1Controller.text,
                "customerAddress2": address2Controller.text,
                "customerAddress3": address3Controller.text,
                "customerPostal_code": postalCodeController.text,
                "currentDate": DateFormat('dd/MM/yyyy').format(selectedDate),
              });

              Get.snackbar("Success", "Added successfully");
              Get.to(() => Contractordetails(
                    docName: customerId.toString(),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.greenColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: mq.width * 0.1,
              height: mq.height * 0.05,
              child: Center(
                child: Text("Next"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
