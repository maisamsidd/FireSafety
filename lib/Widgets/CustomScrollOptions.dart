import 'package:flutter/material.dart';
import '../Utils/AppColors.dart';

class CustomScrollOptionButton extends StatefulWidget {
  final List<String> options;
  final double width;
  final TextStyle textStyle;
  final Function(String) onValueSelected;

  const CustomScrollOptionButton({
    super.key,
    required this.options,
    required this.onValueSelected,
    this.width = 370,
    this.textStyle = const TextStyle(),
  });

  @override
  State<CustomScrollOptionButton> createState() =>
      _CustomScrollOptionButtonState();
}

class _CustomScrollOptionButtonState extends State<CustomScrollOptionButton> {
  bool isOpen = false;
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options.first; // Default to the first option
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: MyColors.blackColor,
                  border: Border.all(color: MyColors.whiteColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedOption, style: widget.textStyle),
                      Icon(
                        Icons.arrow_drop_down,
                        color: MyColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isOpen)
            SizedBox(
              height: 200, // Adjust the height as needed
              child: ListView(
                children: widget.options
                    .map((option) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedOption = option;
                                isOpen = false;
                              });
                              widget.onValueSelected(selectedOption);
                            },
                            child: Container(
                              width: widget.width,
                              color: MyColors.blackColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(option, style: widget.textStyle),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
