import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';


class NoDataFound extends StatelessWidget {
  final String msg;

  const NoDataFound({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: msg.text.color(Colors.black).size(26).fontWeight(FontWeight.w900).make(),
      ),
    );
  }
}
