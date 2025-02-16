import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class Businessdetails extends StatelessWidget {
  const Businessdetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.redColor,
        title: Text(
          "Business Details",
          style: TextStyle(
              color: MyColors.yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Steven Mitchell",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              Text(
                "22 Turrell Drive",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              Text(
                "Kessingland",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              Text(
                "NR33 7UA",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Accreditiantion number",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              Text(
                "IFE 00084022",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Company",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
              Text(
                "Fire Safety Suffolk Ltd",
                style: TextStyle(fontSize: 24, color: MyColors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
