import 'package:fire_safety_suffolk/Utils/AppColors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Purplebutton extends StatelessWidget {
  final String text;
  void Function()? ontap;
  Purplebutton({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: mq.width * 0.4,
        height: mq.height * 0.05,
        decoration: BoxDecoration(
            color: MyColors.purpleColor,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: MyColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
