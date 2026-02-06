
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../state/resume_provider.dart';
import '../../models/resume_model.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  void _openEditor({Education? education}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: EducationEditor(
          education: education,
          onSave: (edu) {
            final currentList = ref.read(resumeProvider).education;
            if (education == null) {
              ref.read(resumeProvider.notifier).updateEducation([...currentList, edu]);
            } else {
              final newList = currentList.map((e) => e.id == edu.id ? edu : e).toList();
              ref.read(resumeProvider.notifier).updateEducation(newList);
            }
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _delete(String id) {
    final currentList = ref.read(resumeProvider).education;
    final newList = currentList.where((e) => e.id != id).toList();
    ref.read(resumeProvider.notifier).updateEducation(newList);
  }

  @override
  Widget build(BuildContext context) {
    final educationList = ref.watch(resumeProvider).education;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        label: const Text("Add Education"),
        icon: const Icon(Icons.school),
      ),
      body: educationList.isEmpty
          ? const Center(
              child: Text(
                "No education added yet.\nTap 'Add Education' to start.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: educationList.length,
              itemBuilder: (ctx, i) {
                final edu = educationList[i];
                final dateFormat = DateFormat('MMM yyyy');
                String dateRange = "";
                if (edu.startDate != null && edu.endDate != null) {
                  dateRange = "${dateFormat.format(edu.startDate!)} - ${dateFormat.format(edu.endDate!)}";
                }
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(edu.institution, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(edu.degree, style: const TextStyle(fontWeight: FontWeight.w500)),
                        if (dateRange.isNotEmpty) Text(dateRange, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _openEditor(education: edu),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _delete(edu.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class EducationEditor extends StatefulWidget {
  final Education? education;
  final ValueChanged<Education> onSave;

  const EducationEditor({super.key, this.education, required this.onSave});

  @override
  State<EducationEditor> createState() => _EducationEditorState();
}

class _EducationEditorState extends State<EducationEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolCtrl;
  late TextEditingController _degreeCtrl;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final e = widget.education;
    _schoolCtrl = TextEditingController(text: e?.institution ?? '');
    _degreeCtrl = TextEditingController(text: e?.degree ?? '');
    _startDate = e?.startDate;
    _endDate = e?.endDate;
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(Education(
        id: widget.education?.id ?? const Uuid().v4(),
        institution: _schoolCtrl.text,
        degree: _degreeCtrl.text,
        startDate: _startDate,
        endDate: _endDate,
        description: '', // Description optional for education usually
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 500,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text("Education Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _schoolCtrl,
              decoration: const InputDecoration(labelText: "Institution / University", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _degreeCtrl,
              decoration: const InputDecoration(labelText: "Degree / Certificate", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(true),
                    child: Text(_startDate == null ? "Start Date" : DateFormat('MMM yyyy').format(_startDate!)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(false),
                    child: Text(_endDate == null ? "End Date" : DateFormat('MMM yyyy').format(_endDate!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: const Text("Save Education"),
            ),
          ],
        ),
      ),
    );
  }
}
