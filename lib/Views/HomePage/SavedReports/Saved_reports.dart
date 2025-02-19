import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/customerData.dart';
import 'package:flutter/material.dart';

class SavedReports extends StatefulWidget {
  const SavedReports({super.key});

  @override
  State<SavedReports> createState() => _SavedReportsState();
}

class _SavedReportsState extends State<SavedReports> {
  @override
  Widget build(BuildContext context) {
    // Accessing the Firestore collection
    final fireStore = FirebaseFirestore.instance.collection("data");

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore.snapshots(),
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

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No data found"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String customerName =
                        snapshot.data!.docs[index]["customerName"].toString();
                    String customerId =
                        snapshot.data!.docs[index]["customerId"].toString();
                    String customerSerial =
                        snapshot.data!.docs[index]["customerSerial"].toString();
                    String currentDate =
                        snapshot.data!.docs[index]["currentDate"].toString();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerDataSaved(
                                      customerId: customerId)));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf,
                              color: Colors.white),
                          title: Text(
                            customerName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(currentDate,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(customerSerial,
                              style: const TextStyle(color: Colors.white)),
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
