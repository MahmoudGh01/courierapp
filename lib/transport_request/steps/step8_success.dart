import 'package:flutter/material.dart';

class Step8Success extends StatelessWidget {
  const Step8Success({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle, color: theme.primaryColor, size: 72),
          const SizedBox(height: 12),
          Text('Success! Transport request created.', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to dashboard'),
          ),
        ]),
      ),
    );
  }
}
