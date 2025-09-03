import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';

class Step6Additional extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step6Additional({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    // Controller reconstruit à chaque build (OK car on pousse via onChanged)
    final txt = TextEditingController(text: p.dto.additionalInstructions ?? '');

    return Scaffold(
      backgroundColor: kWhiteColor, // ✅ fond clair
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

                      // ---- Titre ----
                      Text(
                        'Step 6 of 8 — Additional Information',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // ---- Zone Upload (grand conteneur + bouton centré) ----
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
                                  if ((f.size <= 4 * 1024 * 1024) && f.path != null) {
                                    // ≤ 4MB et chemin valide
                                    // ignore: use_build_context_synchronously
                                    context.read<TransportRequestProvider>().addDocumentPath(f.path!);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ---- Liste des documents sélectionnés ----
                      if (p.dto.documentPaths.isNotEmpty) ...[
                        Text('Attached Documents', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: p.dto.documentPaths.length,
                          itemBuilder: (_, i) {
                            final path = p.dto.documentPaths[i];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.description_outlined),
                                title: Text(
                                  path,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      context.read<TransportRequestProvider>().removeDocumentPath(i),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],

                      // ---- Instructions additionnelles ----
                      TextFormField(
                        controller: txt,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Additional Instructions',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) =>
                            context.read<TransportRequestProvider>().setAdditionalInstructions(v),
                      ),

                      const SizedBox(height: 300),

                      // ---- Footer ----
                      Row(
                        children: [
                          OutlinedButton(onPressed: onBack, child: const Text('Back')),
                          const Spacer(),
                          ElevatedButton(onPressed: onNext, child: const Text('Continue  ↓')),
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
