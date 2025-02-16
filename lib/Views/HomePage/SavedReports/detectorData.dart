import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Utils/Apis/apis.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class DetectorsData extends StatefulWidget {
  final String docName;
  const DetectorsData({super.key, required this.docName});

  @override
  State<DetectorsData> createState() => _CustDetectorsState();
}

class _CustDetectorsState extends State<DetectorsData> {
  void _showEditDialog(
      DocumentSnapshot doc, String field, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new value for $field"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await doc.reference.update({field: controller.text});
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        backgroundColor: MyColors.yellowColor,
        title: Text(
          "Detector Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MyColors.redColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: MyApis.addDetectorsCollection
                  .doc(widget.docName)
                  .collection("detectorsData")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "An error occurred while fetching data.",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No detectors found.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      color: MyColors.yellowColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEditableText(data, "Function test PF"),
                            _buildEditableText(data, "ID NO"),
                            _buildEditableText(data, "Location"),
                            _buildEditableText(data, "Push button test"),
                            _buildEditableText(data, "System silence check"),
                            _buildEditableText(data, "Type"),
                            _buildEditableText(data, "date_completed"),
                          ],
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

  Widget _buildEditableText(DocumentSnapshot doc, String field) {
    final value = doc.get(field) ?? "N/A";
    return GestureDetector(
      onTap: () => _showEditDialog(doc, field, value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          "$field: $value",
          style: TextStyle(
            fontSize: 16,
            color: MyColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
