import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/detectorData.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDetectorsDetailsSaved extends StatefulWidget {
  final String docName;
  const AddDetectorsDetailsSaved({super.key, required this.docName});

  @override
  State<AddDetectorsDetailsSaved> createState() =>
      _AddDetectorsDetailsSavedState();
}

String detector = "Detectors";

class _AddDetectorsDetailsSavedState extends State<AddDetectorsDetailsSaved> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.redColor,
        title: const Text("Add Detectors"),
      ),
      backgroundColor: MyColors.greYColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection(widget.docName)
                  .orderBy("number")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Some error occurred"));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text("No detectors found"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    String detectorName = docs[index]["detectors"].toString();
                    String detectorId = docs[index].id;

                    return ListTile(
                      title: InkWell(
                        onTap: () {
                          Get.to(() => DetectordataSaved(
                                customerId: widget.docName,
                                detectorName: detectorName,
                              ));
                        },
                        child: Text(
                          detectorName,
                          style: TextStyle(
                              color: MyColors.whiteColor, fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
