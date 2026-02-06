
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../state/resume_provider.dart';
import '../../models/resume_model.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends ConsumerState<ExperienceScreen> {
  void _openEditor({Experience? experience}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: ExperienceEditor(
          experience: experience,
          onSave: (exp) {
            if (experience == null) {
              ref.read(resumeProvider.notifier).addExperience(exp);
            } else {
              ref.read(resumeProvider.notifier).updateExperience(exp);
            }
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final experienceList = ref.watch(resumeProvider).experience;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        label: const Text("Add Job"),
        icon: const Icon(Icons.add),
      ),
      body: experienceList.isEmpty
          ? const Center(
              child: Text(
                "No work experience added yet.\nTap 'Add Job' to start.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.only(bottom: 80), // Space for FAB
              onReorder: (oldIndex, newIndex) {
                 ref.read(resumeProvider.notifier).reorderExperience(oldIndex, newIndex);
              },
              children: [
                for (int i = 0; i < experienceList.length; i++)
                  _buildExperienceTile(experienceList[i], Key(experienceList[i].id))
              ],
            ),
    );
  }

  Widget _buildExperienceTile(Experience exp, Key key) {
    final dateFormat = DateFormat('MMM yyyy');
    String dateRange = "";
    if (exp.startDate != null) {
      dateRange = "${dateFormat.format(exp.startDate!)} - ";
      if (exp.isCurrent) {
        dateRange += "Present";
      } else if (exp.endDate != null) {
        dateRange += dateFormat.format(exp.endDate!);
      }
    }

    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(exp.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exp.company),
            if (dateRange.isNotEmpty) Text(dateRange, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (exp.description.isNotEmpty) 
              Text(
                exp.description, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _openEditor(experience: exp),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(resumeProvider.notifier).removeExperience(exp.id);
              },
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class ExperienceEditor extends StatefulWidget {
  final Experience? experience;
  final ValueChanged<Experience> onSave;

  const ExperienceEditor({super.key, this.experience, required this.onSave});

  @override
  State<ExperienceEditor> createState() => _ExperienceEditorState();
}

class _ExperienceEditorState extends State<ExperienceEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _descCtrl;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;

  @override
  void initState() {
    super.initState();
    final e = widget.experience;
    _titleCtrl = TextEditingController(text: e?.jobTitle ?? '');
    _companyCtrl = TextEditingController(text: e?.company ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _startDate = e?.startDate;
    _endDate = e?.endDate;
    _isCurrent = e?.isCurrent ?? false;
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
      widget.onSave(Experience(
        id: widget.experience?.id ?? const Uuid().v4(),
        jobTitle: _titleCtrl.text,
        company: _companyCtrl.text,
        startDate: _startDate,
        endDate: _endDate,
        isCurrent: _isCurrent,
        description: _descCtrl.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 600, // Fixed height or flexible
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text("Job Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: "Job Title", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _companyCtrl,
              decoration: const InputDecoration(labelText: "Company", border: OutlineInputBorder()),
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
                    onPressed: _isCurrent ? null : () => _pickDate(false),
                    child: Text(_isCurrent 
                      ? "Present" 
                      : (_endDate == null ? "End Date" : DateFormat('MMM yyyy').format(_endDate!))),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text("I currently work here"),
              value: _isCurrent,
              onChanged: (v) => setState(() {
                _isCurrent = v!;
                if (v) _endDate = null;
              }),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: "Description (Bullet points recommended)",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: const Text("Save Experience"),
            ),
          ],
        ),
      ),
    );
  }
}
