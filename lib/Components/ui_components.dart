// lib/transport/widgets/ui_components.dart
import 'package:flutter/material.dart';
import 'package:courier_app/Theme/colors.dart';

/// Generic section container with white background, radius, and shadow
class SectionCard extends StatelessWidget {
  final String? title;              // optional title
  final Widget child;               // section content
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin, // spacing around
      decoration: BoxDecoration(
        color: kWhiteColor, // white card
        borderRadius: BorderRadius.circular(16), // rounded
        boxShadow: [
          BoxShadow( // subtle shadow
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding!, // inner spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
            child, // main content
          ],
        ),
      ),
    );
  }
}

/// Large tappable card used for Step 1 (bigger selectable options)
class BigSelectCard extends StatelessWidget {
  final IconData icon;                // left icon
  final String title;                 // main title
  final String subtitle;              // description
  final bool selected;                // current selection
  final VoidCallback onTap;           // handler

  const BigSelectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),                // bigger padding
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor.withOpacity(0.08) : kWhiteColor,
          border: Border.all(
            color: selected ? theme.primaryColor : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,                                   // bigger icon avatar
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Icon(icon, color: theme.primaryColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.primaryColorDark,
                      )),
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                        height: 1.35,
                      )),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? theme.primaryColor : theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Labeled dropdown with rounded filled background
class LabeledDropdown<T> extends StatelessWidget {
  final String label;                  // label text
  final T? value;                      // current selected
  final List<DropdownMenuItem<T>> items; // list
  final ValueChanged<T?> onChanged;    // handler

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: kButtonColor, // light filled, consistent with app
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<T>(
            decoration: const InputDecoration(
              border: InputBorder.none, // clean input
            ),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Big upload area box with CTA button inside
class UploadBox extends StatelessWidget {
  final String title;                 // header
  final String subtitle;              // helper line
  final VoidCallback onPickFiles;     // button action
  final Widget? footer;               // optional footer (file list)

  const UploadBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPickFiles,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 10),
          Container(
            height: 180, // bigger click target
            decoration: BoxDecoration(
              color: kButtonColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPickFiles,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file, color: theme.primaryColor, size: 38),
                    const SizedBox(height: 8),
                    Text(
                      'Click to upload or drag & drop',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle, // e.g. "PDF, JPG, PNG - Up to 4MB"
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ]
        ],
      ),
    );
  }
}
