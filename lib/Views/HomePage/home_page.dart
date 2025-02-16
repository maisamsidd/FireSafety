import 'package:fire_safety_suffolk/Views/HomePage/BusinessDetails.dart';
import 'package:fire_safety_suffolk/Views/HomePage/SavedReports/Saved_reports.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/CustomerDetails.dart';
import 'package:flutter/material.dart';
import 'package:fire_safety_suffolk/Utils/AppColors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyColors.whiteColor),
        backgroundColor: MyColors.blackColor,
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
          children: [
            const SizedBox(height: 20), // Add some space at the top
            Image.asset("assets/images/logo_1.jpg"),
            const SizedBox(
              height: 50,
              width: 50,
            ), // Add space between the logo and buttons
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Move buttons to the bottom
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Customerdetails()));
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Customerdetails()));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(color: MyColors.redColor),
                      child: const Center(
                        child: Text(
                          "Customer Details",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SavedReports()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(color: MyColors.yellowColor),
                    child: const Center(
                      child: Text(
                        "Saved Reports",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Businessdetails()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(color: MyColors.greenColor),
                    child: const Center(
                      child: Text(
                        "Business Details",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
