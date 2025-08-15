import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;

  const CustomAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left),
        color: kWhiteColor,
        iconSize: 40,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title ?? '',
        style: TextStyle(
          color: kWhiteColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
