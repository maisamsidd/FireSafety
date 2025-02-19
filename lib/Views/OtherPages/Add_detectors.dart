import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/ContractorDetails.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDetectors extends StatefulWidget {
  final String docName;
  const AddDetectors({super.key, required this.docName});

  @override
  State<AddDetectors> createState() => _AddDetectorsState();
}

class _AddDetectorsState extends State<AddDetectors> {
  final fireStore = FirebaseFirestore.instance;
  bool isAddingDetector = false; // Prevent duplicate writes

  Future<void> addDetector() async {
    if (isAddingDetector) return; // Prevent multiple taps
    setState(() {
      isAddingDetector = true;
    });

    try {
      // Fetch existing detectors
      final snapshot =
          await fireStore.collection(widget.docName).orderBy("number").get();

      // Determine the next detector number
      int nextNumber = 1;
      if (snapshot.docs.isNotEmpty) {
        nextNumber = snapshot.docs.last["number"] + 1;
      }

      String newDetector = "Detector $nextNumber";

      // Check if the detector already exists
      bool detectorExists = snapshot.docs.any((doc) =>
          doc["detectors"].toString().toLowerCase() ==
          newDetector.toLowerCase());

      if (!detectorExists) {
        // Add the new detector
        await fireStore.collection(widget.docName).add({
          "detectors": newDetector,
          "number": nextNumber,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detector added successfully')),
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
    } finally {
      setState(() {
        isAddingDetector = false; // Allow future writes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
        title: const Text("Add Detectors"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: MyColors.greYColor,
      body: Column(
        children: [
          GestureDetector(
            onTap: addDetector,
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
                  child:
                      // isAddingDetector
                      //     ? const CircularProgressIndicator(
                      //         color: Colors.white,
                      //       )
                      //     :
                      Text(
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
      bottomNavigationBar: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => Contractordetails(
                    docName: widget.docName,
                  ));
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
