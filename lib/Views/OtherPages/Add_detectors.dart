import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDetectors extends StatefulWidget {
  final String docName;
  const AddDetectors({super.key, required this.docName});

  @override
  State<AddDetectors> createState() => _AddDetectorsState();
}

String detector = "Detectors";

class _AddDetectorsState extends State<AddDetectors> {
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
          GestureDetector(
            onTap: () async {
              try {
                final snapshot = await fireStore
                    .collection("data")
                    .doc(widget.docName)
                    .collection("details")
                    .get();

                int nextNumber = snapshot.docs.length + 1;
                String newDetector = "Detector $nextNumber";

                final existingDetector = await fireStore
                    .collection("data")
                    .doc(widget.docName)
                    .collection("details")
                    .doc(newDetector)
                    .get();

                if (!existingDetector.exists) {
                  await fireStore
                      .collection("data")
                      .doc(widget.docName)
                      .collection("details")
                      .doc(newDetector)
                      .set({
                    "detectors": newDetector,
                    "number": nextNumber,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Detector added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Detector already exists')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: mq.height * 0.1,
              color: MyColors.blackColor,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: MyColors.purpleColor,
                  ),
                  child: Text(
                    "Add Detector",
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
