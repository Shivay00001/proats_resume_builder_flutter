
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/resume_provider.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  late TextEditingController _summaryController;
  
  // ATS Tip: Keep it between 3-5 sentences, approx 300-500 chars is good.
  static const int _recommendedMaxChars = 500;

  @override
  void initState() {
    super.initState();
    final currentSummary = ref.read(resumeProvider).summary;
    _summaryController = TextEditingController(text: currentSummary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(resumeProvider.notifier).updateSummary(_summaryController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Professional Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "ATS Tip: Keep it concise. Use industry keywords. Avoid first-person pronouns (I, me, my).",
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _summaryController,
            maxLines: 8,
            maxLength: 1000,
            decoration: const InputDecoration(
              hintText: "Experienced Software Engineer with 5+ years of expertise in Flutter and Dart...",
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: (v) {
              setState(() {}); // Rebuild for counter
              _save();
            },
          ),
          const SizedBox(height: 8),
          if (_summaryController.text.length > _recommendedMaxChars)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Warning: Long summaries may be truncated by some ATS. Aim for < $_recommendedMaxChars chars.",
                style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
