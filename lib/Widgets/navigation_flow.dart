// import 'package:fire_safety_suffolk/Utils/AppColors.dart';
// import 'package:fire_safety_suffolk/Views/HomePage/home_page.dart';
// import 'package:fire_safety_suffolk/Views/OtherPages/ContractorDetails.dart';
// import 'package:fire_safety_suffolk/Views/OtherPages/detectors.dart';
// import 'package:flutter/material.dart';

// class NavigationFlow extends StatefulWidget {
//   final String docName;

//   const NavigationFlow({super.key, required this.docName});
//   @override
//   _NavigationFlowState createState() => _NavigationFlowState();
// }

// class _NavigationFlowState extends State<NavigationFlow> {
//   final PageController _pageController = PageController(initialPage: 0);

//   void _navigateToPage(int page) {
//     _pageController.animateToPage(
//       page,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
//         children: [
//           // Replace with your widget          Customerdetails(docName: widget.docName), // Replace with your widget
//           Detectors(docName: widget.docName), // Replace with your widget
//           Contractordetails(docName: widget.docName) // Replace with your widget
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             InkWell(
//               onTap: () {
//                 if (_pageController.page! > 0) {
//                   _navigateToPage(_pageController.page!.toInt() - 1);
//                 }
//               },
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: MyColors.purpleColor,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(color: MyColors.blackColor),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_left,
//                   size: 50,
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomePage()),
//                 );
//               },
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: MyColors.purpleColor,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(color: MyColors.blackColor),
//                 ),
//                 child: const Icon(
//                   Icons.home,
//                   size: 50,
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 if (_pageController.page! < 3) {
//                   _navigateToPage(_pageController.page!.toInt() + 1);
//                 }
//               },
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: MyColors.purpleColor,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(color: MyColors.blackColor),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_right,
//                   size: 50,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
