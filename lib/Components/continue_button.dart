import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final Color? borderColor;
  final Color? color;
  final TextStyle? style;
  final BorderRadius? radius;
  final double? padding;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.borderColor,
    this.color,
    this.style,
    this.radius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MaterialButton(
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: padding ?? 20),
      onPressed: onPressed as void Function()?,
      disabledColor: theme.disabledColor,
      color: color ?? theme.primaryColor,
      shape: OutlineInputBorder(
        borderRadius: radius ?? BorderRadius.zero,
        borderSide: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      child: FadedScaleAnimation(
        child: Text(
          text ?? AppLocalizations.of(context).continueText,
          style: style ??
              Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
        ),
      ),
    );
  }
}
