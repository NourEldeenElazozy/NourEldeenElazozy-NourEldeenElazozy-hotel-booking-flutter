import 'package:flutter/material.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: const BoxDecoration(
          color: MyColors.primaryColor, shape: BoxShape.circle),
      child: const Stack(alignment: Alignment.center, children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ]),
    );
  }
}
