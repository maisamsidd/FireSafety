import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/Saved_reports.dart';
import 'package:fire_safety_suffolk/Views/HomePage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCuL4G8J9Y1rcKQ4gPaaswXLX6ElMLUwuk",
          appId: "1:850741063556:web:e9395f3ae7cbd1fc0837d1",
          messagingSenderId: "850741063556",
          projectId: "fire-safety-6370b"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
