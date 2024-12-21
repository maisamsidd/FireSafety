import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fire_safety_suffolk/Utils/Apis/apis.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Utils/purpleButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class Contractordetails extends StatefulWidget {
  const Contractordetails({super.key});

  @override
  State<Contractordetails> createState() => _ContractordetailsState();
}

class _ContractordetailsState extends State<Contractordetails> {
  final engineerController = TextEditingController();
  final accredentialDetailsController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  File? _signatureImage;
  String? _signatureImageUrl;

  Future<void> _pickSignatureImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _signatureImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadSignatureImage() async {
    if (_signatureImage == null) return;

    final fileName = 'signatures/${DateTime.now().millisecondsSinceEpoch}.png';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      final uploadTask = await storageRef.putFile(_signatureImage!);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      setState(() {
        _signatureImageUrl = downloadUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload signature: $e')),
      );
    }
  }

  void _generateReference() async {
    await _uploadSignatureImage();

    MyApis.contractorDetails.add({
      "engineer": engineerController.text,
      "accredentials": accredentialDetailsController.text,
      "address1": address1Controller.text,
      "address2": address2Controller.text,
      "address3": address3Controller.text,
      "signatureUrl": _signatureImageUrl, // Store the signature URL
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reference Generated Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
        title: Text("Details of Contractor",
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
              Text("INSPECTED BY",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              Text("Engineer (Capitals)",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: engineerController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              Text("Signature", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.upload_file, color: MyColors.whiteColor),
                    onPressed: _pickSignatureImage,
                  ),
                  if (_signatureImage != null)
                    Text("Signature Selected",
                        style: TextStyle(color: MyColors.greenColor)),
                ],
              ),
              SizedBox(height: mq.height * 0.01),
              Text("Accreditation details",
                  style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: accredentialDetailsController,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              Text("Date", style: TextStyle(color: MyColors.whiteColor)),
              SizedBox(height: mq.height * 0.01),
              Text("Contractor details",
                  style: TextStyle(color: MyColors.whiteColor)),
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
                child: TextField(
                  controller: address2Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Address 2", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: address3Controller,
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Address 3", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
              SizedBox(
                width: 250,
                child: TextField(
                  style: TextStyle(color: MyColors.whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Postal code", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Purplebutton(
                ontap: _generateReference,
                text: "Generate Reference",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
