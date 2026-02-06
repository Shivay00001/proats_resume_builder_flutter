
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/resume_provider.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  late TextEditingController _controller;
  List<String> _parsedSkills = [];

  @override
  void initState() {
    super.initState();
    // Load existing skills initially
    _parsedSkills = ref.read(resumeProvider).skills;
    
    // Convert to comma separated string for the text field
    _controller = TextEditingController(text: _parsedSkills.join(", "));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    final raw = value.split(',');
    final cleanList = raw
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() {
      _parsedSkills = cleanList;
    });

    ref.read(resumeProvider.notifier).updateSkills(cleanList);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
           const Text(
            "Enter your skills separated by commas (e.g. Flutter, Dart, Firebase, Team Leadership).",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Java, Python, Project Management...",
              border: OutlineInputBorder(),
            ),
            onChanged: _onTextChanged,
          ),
          const SizedBox(height: 24),
          const Text("Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_parsedSkills.isEmpty)
            const Text("No skills added yet.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _parsedSkills.map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.blue.shade50,
                side: BorderSide.none,
              )).toList(),
            ),
        ],
      ),
    );
  }
}
