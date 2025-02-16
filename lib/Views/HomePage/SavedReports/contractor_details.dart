import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/addDetectorsData.dart';
import 'package:fire_safety_suffolk/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContractordetailsReport extends StatefulWidget {
  final String customerId;
  const ContractordetailsReport({super.key, required this.customerId});

  @override
  State<ContractordetailsReport> createState() =>
      _ContractordetailsReportState();
}

class _ContractordetailsReportState extends State<ContractordetailsReport> {
  final engineerController = TextEditingController();
  final accredentialDetailsController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final additionalComments = TextEditingController();
  final postalCode = TextEditingController();
  File? _signatureImage;
  String? _signatureImageUrl;

  @override
  void initState() {
    super.initState();

    // Setting default values for text fields
    engineerController.text = "Steven Mitchel";
    accredentialDetailsController.text = "Enter Accreditation Details";
    address1Controller.text = "22 Turrell Drive";
    address2Controller.text = "Kessingland";
    address3Controller.text = "NR33 7UA";
    additionalComments.text = "None";
    postalCode.text = "7612";
  }

  void _generateReference() async {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    // await fireStore
    //     .collection("data")
    //     .doc(widget.docName)
    //     .collection("ContractorDetails")
    //     .doc()
    //     .set({
    //   "customerId": widget.docName,
    //   "contractorEngineer": engineerController.text,
    //   "contractorAccredentials": accredentialDetailsController.text,
    //   "contractorAddress1": address1Controller.text,
    //   "contractorAddress2": address2Controller.text,
    //   "contractorAddress3": address3Controller.text,
    //   "contractorSignatureUrl": _signatureImageUrl,
    //   "currentDate": formattedDate,
    //   "additionalComments": additionalComments.text,
    //   "postalCode": postalCode.text
    // });

    Get.to(() => AddDetectorsDetails(docName: widget.customerId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reference Generated Successfully ${widget.customerId}'),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hintText,
      bool isMultiline = false}) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        maxLines: isMultiline ? null : 1,
        style: TextStyle(color: MyColors.whiteColor),
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
        title: Text(
          "Details of Contractor",
          style: TextStyle(color: MyColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.height * 0.01),
              Text("INSPECTED BY",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              Text("Engineer (Capitals)",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: engineerController, hintText: "Engineer Name"),
              SizedBox(height: mq.height * 0.01),
              Text("Accreditation details",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: accredentialDetailsController,
                  hintText: "Accreditation Details"),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: additionalComments,
                  hintText: "Additional Comments",
                  isMultiline: true),
              SizedBox(height: mq.height * 0.01),
              Text("Contractor details",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: address1Controller, hintText: "Address 1"),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: address2Controller, hintText: "Address 2"),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(
                  controller: address3Controller, hintText: "Address 3"),
              SizedBox(height: mq.height * 0.01),
              _buildTextField(controller: postalCode, hintText: "Postal code"),
              SizedBox(height: mq.height * 0.02),
              Purplebutton(
                ontap: _generateReference,
                text: "See detectors List",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
