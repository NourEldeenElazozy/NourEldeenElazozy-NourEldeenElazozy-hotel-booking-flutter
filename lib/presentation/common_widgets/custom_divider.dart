import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double? size;
  const CustomDivider({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * size!,
      child: const Divider(),
    );
  }
}
