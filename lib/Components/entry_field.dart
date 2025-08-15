import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';

class EntryField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? image;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onSuffixPressed;
  final bool? isPassword;
  final Function(String)? onChanged;

  // ✅ New
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool? enabled;

  const EntryField({
    super.key,
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.suffixIcon,
    this.maxLines,
    this.onTap,
    this.textCapitalization,
    this.onSuffixPressed,
    this.isPassword,
    this.onChanged,
    // ✅ New
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.focusNode,
    this.enabled,
  });

  @override
  State<EntryField> createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TextFormField doesn't allow controller + initialValue together.
    final useInitialValue = widget.controller == null && (widget.initialValue?.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.label != null && widget.label!.isNotEmpty)
            Text(
              widget.label!,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColorDark,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          TextFormField(
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
            textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
            cursorColor: kMainColor,
            autofocus: false,
            onTap: widget.onTap,
            controller: widget.controller,
            initialValue: useInitialValue ? widget.initialValue : null,
            readOnly: widget.readOnly ?? false,
            enabled: widget.enabled ?? true,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            maxLines: (widget.isPassword == true) ? 1 : (widget.maxLines ?? 1),
            obscureText: (widget.isPassword == true) ? _obscureText : false,
            onChanged: widget.onChanged,
            validator: widget.validator,                    // ✅ wired up
            autovalidateMode: widget.autovalidateMode,      // ✅ optional
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
              counter: const Offstage(),
              suffixIcon: _buildSuffixIcon(),
              errorMaxLines: 2,
              // Optional: add border styles that match your app
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMainColor)),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword == true) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: kMainColor,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, size: 24.0, color: kMainColor),
        onPressed: widget.onSuffixPressed,
      );
    }
    return null;
  }
}
