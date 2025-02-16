import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateDataPage extends StatelessWidget {
  final String docName;

  const CertificateDataPage({super.key, required this.docName});

  Future<Map<String, dynamic>> fetchCertificateData(String docName) async {
    try {
      // Fetch detector details
      final detectorCustomerSnapshot = await FirebaseFirestore.instance
          .collection("addDetectorsCollection")
          .doc(docName)
          .collection("customerDetails")
          .get();
      final detectorContractorSnapshot = await FirebaseFirestore.instance
          .collection("addDetectorsCollection")
          .doc(docName)
          .collection("contractorDetails")
          .get();

      // Fetch detectors data
      final detectorsDataSnapshot = await FirebaseFirestore.instance
          .collection("addDetectorsCollection")
          .doc(docName)
          .collection("detectorsData")
          .get();

      // Organize data for UI display
      Map<String, dynamic> data = {
        "customerDetails": detectorCustomerSnapshot.docs.map((doc) {
          return {
            "key1": doc.data()["customerName"] ?? "N/A",
            "key2": doc.data()["customerSerial"] ?? "N/A",
          };
        }).toList(),
        "contractorDetails": detectorContractorSnapshot.docs.map((doc) {
          return {
            "key3": doc.data()["contractorAddress1"] ?? "N/A",
            "key4": doc.data()["contractorAddress2"] ?? "N/A",
          };
        }).toList(),
        "detectors": detectorsDataSnapshot.docs.map((doc) {
          return {
            "Location": doc.data()["Location"] ?? "N/A",
            "Type": doc.data()["Type"] ?? "N/A",
            "Function test P/F": doc.data()["Function test P/F"] ?? "N/A",
            "Push button test": doc.data()["Push button test"] ?? "N/A",
            "System silence check": doc.data()["System silence check"] ?? "N/A",
            "ID NO": doc.data()["ID NO"] ?? "N/A",
            "date_completed": doc.data()["date_completed"] ?? "N/A",
          };
        }).toList(),
      };

      return data;
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate Data"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCertificateData(docName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          }

          final data = snapshot.data!;
          final customerDetails = data["customerDetails"];
          final contractorDetails = data["contractorDetails"];
          final detectors = data["detectors"] as List<dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Detector Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Card(
                child: ListTile(
                  title: Text("Key1: ${customerDetails[0]["key1"]}"),
                  subtitle: Text("Key2: ${customerDetails[0]["key2"]}"),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: Text("Key3: ${contractorDetails[0]["key3"]}"),
                  subtitle: Text("Key4: ${contractorDetails[0]["key4"]}"),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Detectors",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...detectors.map((detector) {
                return Card(
                  child: ListTile(
                    title: Text("Location: ${detector["Location"]}"),
                    subtitle: Text(
                        "Type: ${detector["Type"]}\nFunction test P/F: ${detector["Function test P/F"]}\n"
                        "Push button test: ${detector["Push button test"]}\nSystem silence check: ${detector["System silence check"]}\n"
                        "ID NO: ${detector["ID NO"]}\nDate Completed: ${detector["date_completed"]}"),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
