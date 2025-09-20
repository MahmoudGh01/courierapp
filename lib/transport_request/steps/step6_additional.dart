import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Service/upload_service.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
class Step6Additional extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step6Additional({super.key, required this.onNext, required this.onBack});

  @override
  State<Step6Additional> createState() => _Step6AdditionalState();
}

class _Step6AdditionalState extends State<Step6Additional> {
  late TextEditingController txt;

  @override
  void initState() {
    super.initState();
    final prov = context.read<TransportRequestProvider>();
    txt = TextEditingController(text: prov.dto.additionalInstructions ?? '');

    // Keep provider in sync
    txt.addListener(() {
      prov.setAdditionalInstructions(txt.text);
    });
  }

  @override
  void dispose() {
    txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Step 6 of 8 — Additional Information',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // ---- Upload ----
                      Text('Documents (PDF, JPG, PNG ≤ 4MB)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),

                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.dividerColor.withOpacity(0.4), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Click to upload or drag & drop'),
                            onPressed: () async {
                              final res = await FilePicker.platform.pickFiles(
                                allowMultiple: true,
                                type: FileType.custom,
                                allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                              );

                              if (res != null) {
                                for (final f in res.files) {
                                  if (f.path != null) {
                                    final file = File(f.path!);
                                    if (file.lengthSync() <= 4 * 1024 * 1024) {
                                      try {
                                        final url = await UploadService.uploadFile(file);
                                        if (url != null && context.mounted) {
                                          context.read<TransportRequestProvider>().addDocumentPath(url);
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Upload failed: $e")),
                                          );
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (p.dto.documentPaths!.isNotEmpty) ...[
                        Text('Attached Documents', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: p.dto.documentPaths!.length,
                          itemBuilder: (_, i) {
                            final path = p.dto.documentPaths![i];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.description_outlined),
                                title: Text(path, maxLines: 1, overflow: TextOverflow.ellipsis),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => context.read<TransportRequestProvider>().removeDocumentPath(i),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],

                      TextFormField(
                        controller: txt,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Additional Instructions',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          OutlinedButton(onPressed: widget.onBack, child: const Text('Back')),
                          const Spacer(),
                          ElevatedButton(onPressed: widget.onNext, child: const Text('Continue  ↓')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
