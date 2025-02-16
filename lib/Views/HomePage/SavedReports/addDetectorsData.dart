import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDetectorsDetails extends StatefulWidget {
  final String docName;
  const AddDetectorsDetails({super.key, required this.docName});

  @override
  State<AddDetectorsDetails> createState() => _AddDetectorsDetailsState();
}

String detector = "Detectors";

class _AddDetectorsDetailsState extends State<AddDetectorsDetails> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
        title: const Text("Add Detectors"),
      ),
      backgroundColor: MyColors.greYColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection("data")
                  .doc(widget.docName)
                  .collection("details")
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
                          Get.to(() => Detectors(
                                docName: widget.docName,
                                detectorId: detectorId,
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
