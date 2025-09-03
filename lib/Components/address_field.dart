import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final TextEditingController? controller;

  final String? initialValue;
  final Widget? icon;
  final BorderSide? border;
  final Color? color;
  final Widget? suffix;
  final String? hint;
  final Function? onTap;
  final bool? readOnly;

  const AddressField({
    super.key,
    this.initialValue,
    this.icon,
    this.border,
    this.color,
    this.suffix,
    this.hint,
    this.onTap,
    this.readOnly,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      style: TextStyle(color: theme.primaryColorDark),
      initialValue: initialValue ?? '',
      readOnly: readOnly ?? false,
      onTap: onTap as void Function()?,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hint ?? '',
        suffixIcon: suffix ?? const SizedBox.shrink(),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35.0),
            borderSide: border ?? BorderSide.none),
        counter: const Offstage(),
        fillColor: color ?? kWhiteColor,
        filled: true,
      ),
    );
  }
}
