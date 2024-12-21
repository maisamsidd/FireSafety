import 'package:fire_safety_suffolk/Views/OtherPages/Add_detectors.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/ContractorDetails.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/CustomerDetails.dart';
import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
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
      drawer: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.whiteColor),
        ),
        child: Drawer(
          backgroundColor: MyColors.blackColor,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddDetectors()));
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text("Add Detectors")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Contractordetails()));
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text("Contractor Details")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Customerdetails()));
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text("Customers")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Detectors()));
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text("Detectors")),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
        children: [
          const SizedBox(height: 20), // Add some space at the top
          Center(
            child: Image.network(
              "https://www.firesafetysuffolk.co.uk/images/logo.webp",
              height: 150, // Specify height for consistency
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20), // Add space between the logo and buttons
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Move buttons to the bottom
              children: [
                GestureDetector(
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
                        "New detectors report",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
                Container(
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
                Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
