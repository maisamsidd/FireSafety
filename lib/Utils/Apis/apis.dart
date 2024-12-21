import 'package:cloud_firestore/cloud_firestore.dart';

class MyApis {
  static final contractorDetails =
      FirebaseFirestore.instance.collection("contractorDetails");
  static final customerDetails =
      FirebaseFirestore.instance.collection("customerrDetails");
  static final addDetectorsCollection =
      FirebaseFirestore.instance.collection("addDetectorsCollection");
  static final detectorsCollection =
      FirebaseFirestore.instance.collection("detectorsCollection");
}
