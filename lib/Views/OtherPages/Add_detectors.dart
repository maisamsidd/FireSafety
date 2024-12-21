import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/Apis/apis.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:fire_safety_suffolk/main.dart';
import 'package:flutter/material.dart';

class AddDetectors extends StatelessWidget {
  const AddDetectors({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    int num = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.redColor,
      ),
      backgroundColor: MyColors.greYColor,
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              MyApis.addDetectorsCollection
                  .add({"detectors": "Detector${num += 1}"});
            },
            child: Container(
              width: double.infinity,
              height: mq.height * 0.15,
              color: MyColors.blackColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Container(
                    width: mq.width * 0.15,
                    height: mq.width * 0.03,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColors.purpleColor,
                    ),
                    child: Center(
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
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: MyApis.addDetectorsCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Some error occurred"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Check if the snapshot has data and if it's empty
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No detectors found"),
                  );
                }

                return ListView.builder(
                  itemCount:
                      docs.length, // Set the itemCount to avoid RangeError
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        docs[index]["detectors"].toString(),
                        style: TextStyle(color: MyColors.whiteColor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 40),
            Container(
              width: mq.width * 0.05,
              height: mq.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColors.redColor,
              ),
              child: Center(
                child: Text(
                  "<---",
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors.whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: mq.width * 0.05,
              height: mq.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColors.purpleColor,
              ),
              child: Center(
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors.whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: mq.width * 0.05,
              height: mq.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColors.greenColor,
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
