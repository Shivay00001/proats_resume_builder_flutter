
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../state/resume_provider.dart';
import '../models/resume_model.dart';
import '../templates/base_template.dart';
import '../exporters/exporters.dart';
import '../utils/ats_logic.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  late List<ResumeTemplate> _templates;
  late ResumeTemplate _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _templates = ResumeTemplate.getAll();
    _selectedTemplate = _templates.first;
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(resumeProvider);
    final atsResult = AtsLogic.analyze(resume);
    final scoreColor = atsResult.score > 80 ? Colors.green 
                     : atsResult.score > 50 ? Colors.orange 
                     : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Preview"),
        actions: [
          IconButton(
             icon: const Icon(Icons.analytics_outlined),
             tooltip: "ATS Score",
             onPressed: () => _showAtsResut(context, atsResult, scoreColor),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Export Document",
            onPressed: () => _showExportOptions(context, resume),
          )
        ],
      ),
      body: Column(
        children: [
          // Template Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _templates.length,
              itemBuilder: (ctx, i) {
                final t = _templates[i];
                final isSelected = t.id == _selectedTemplate.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t.name),
                    selected: isSelected,
                    onSelected: (v) {
                      if (v) setState(() => _selectedTemplate = t);
                    },
                  ),
                );
              },
            ),
          ),
          // PDF Preview
          Expanded(
            child: PdfPreview(
              build: (format) async {
                final pdf = await _selectedTemplate.buildPdf(resume);
                return pdf.save();
              },
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              initialPageFormat: PdfPageFormat.a4,
              pdfFileName: "resume.pdf",
            ),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context, ResumeModel resume) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Export as PDF"),
              subtitle: const Text("Best for emailing/uploading"),
              onTap: () async {
                Navigator.pop(ctx);
                final pdf = await _selectedTemplate.buildPdf(resume);
                await Printing.sharePdf(bytes: await pdf.save(), filename: 'resume.pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text("Export as DOCX (Word)"),
              subtitle: const Text("Editable format"),
              onTap: () async {
                 Navigator.pop(ctx);
                 final bytes = DocxExporter.generate(resume);
                 await _saveFile(bytes, "resume.docx", "docx");
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text("Export as Plain Text"),
              subtitle: const Text("For ATS parsing checks"),
              onTap: () async {
                Navigator.pop(ctx);
                final text = TxtExporter.generate(resume);
                await _saveFile(utf8.encode(text), "resume.txt", "txt");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFile(List<int> bytes, String filename, String extension) async {
    // Desktop: Save via FilePicker
    String? path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Resume',
      fileName: filename,
      type: FileType.any, // custom not always supported on all platforms
    );

    if (path != null) {
      // Ensure extension if user removed it
      if (!path.endsWith('.$extension')) {
        path = "$path.$extension";
      }
      final file = File(path);
      await file.writeAsBytes(bytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saved to $path")),
        );
      }
    }
  }

  void _showAtsResut(BuildContext context, AtsCheckResult result, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4, 
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text("ATS Checker Analysis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100, height: 100, 
                      child: CircularProgressIndicator(
                        value: result.score / 100, 
                        strokeWidth: 10, 
                        backgroundColor: Colors.grey[200],
                        color: color,
                      ),
                    ),
                    Text("${result.score}", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Analysis Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              if (result.warnings.isEmpty && result.improvements.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("✅ Great job! No major issues found.", textAlign: TextAlign.center, style: TextStyle(color: Colors.green)),
                ),
                
              if (result.warnings.isNotEmpty) ...[
                 const Text("Critical Issues (Fix these first):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                 ...result.warnings.map((w) => ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(w, style: const TextStyle(fontSize: 14)),
                    dense: true,
                 )),
              ],
              
              if (result.improvements.isNotEmpty) ...[
                 const SizedBox(height: 10),
                 const Text("Suggestions for Improvement:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                 ...result.improvements.map((w) => ListTile(
                    leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
                    title: Text(w, style: const TextStyle(fontSize: 14)),
                    dense: true,
                 )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
