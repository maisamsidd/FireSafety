import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FetchDataPage extends StatefulWidget {
  final String docName;
  final String detectorName;

  FetchDataPage({required this.docName, required this.detectorName});

  @override
  _FetchDataPageState createState() => _FetchDataPageState();
}

class _FetchDataPageState extends State<FetchDataPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final Map<String, String> selectedValues = {
    'Type': '',
    'Function test PF': '',
    'Push button test': '',
    'System silence check': '',
  };
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fireStore = FirebaseFirestore.instance;

      DocumentSnapshot doc = await fireStore
          .collection(widget.docName)
          .doc(widget.detectorName)
          .get();

      print(widget.detectorName);

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        setState(() {
          locationController.text = data['Location'] ?? '';
          idController.text = data['ID NO'] ?? '';
          selectedValues['Type'] = data['Type'] ?? '';
          selectedValues['Function test PF'] = data['Function test PF'] ?? '';
          selectedValues['Push button test'] = data['Push button test'] ?? '';
          selectedValues['System silence check'] =
              data['System silence check'] ?? '';
          if (data['date_completed'] != null) {
            selectedDate =
                DateFormat('dd/MM/yyyy').parse(data['date_completed']);
          }
        });
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Detector Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID NO'),
            ),
            DropdownButtonFormField<String>(
              value: selectedValues['Type'],
              onChanged: (value) {
                setState(() {
                  selectedValues['Type'] = value!;
                });
              },
              items: ['Type 1', 'Type 2', 'Type 3']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Type'),
            ),
            // Add similar DropdownButtonFormField widgets for the other fields
            if (selectedDate != null)
              Text(
                  'Date Completed: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}
