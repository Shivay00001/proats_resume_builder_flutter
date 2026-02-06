
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/resume_model.dart';
import 'base_template.dart';

class MinimalTemplate extends ResumeTemplate {
  @override
  String get name => "Minimal Clean";
  @override
  String get id => "minimal";

  @override
  Future<pw.Document> buildPdf(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: AtsStyles.getPageTheme(),
        build: (context) => [
          // Minimal Header: Left aligned name
          pw.Text(resume.personalDetails.fullName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 22)),
          pw.SizedBox(height: 2),
           pw.Text(
            [
              resume.personalDetails.email,
              resume.personalDetails.phone,
              resume.personalDetails.location
            ].where((e) => e.isNotEmpty).join("  •  "),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),

          if (resume.summary.isNotEmpty) ...[
            _section("SUMMARY"),
            pw.Text(resume.summary, style: AtsStyles.bodyStyle),
            pw.SizedBox(height: 15),
          ],
          if (resume.experience.isNotEmpty) ...[
            _section("EXPERIENCE"),
            ...resume.experience.map((e) => _item(e)),
            pw.SizedBox(height: 15),
          ],
           if (resume.education.isNotEmpty) ...[
            _section("EDUCATION"),
            ...resume.education.map((e) => _eduItem(e)),
            pw.SizedBox(height: 15),
          ],
           if (resume.skills.isNotEmpty) ...[
            _section("SKILLS"),
            pw.Text(resume.skills.join("  •  "), style: AtsStyles.bodyStyle),
          ],
        ],
      ),
    );
    return pdf;
  }

  pw.Widget _section(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 5),
      ]
    );
  }

  pw.Widget _item(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(exp.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(_date(exp), style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
          pw.Text(exp.company, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 2),
          pw.Text(exp.description, style: AtsStyles.bodyStyle),
        ],
      ),
    );
  }
  
  pw.Widget _eduItem(Education edu) {
     return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Text(_eduDate(edu), style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  String _date(Experience exp) {
     if (exp.startDate == null) return "";
     if (exp.isCurrent) return "${exp.startDate!.year} - Present";
     if (exp.endDate == null) return "${exp.startDate!.year}";
     return "${exp.startDate!.year} - ${exp.endDate!.year}";
  }
  
  String _eduDate(Education edu) {
    if (edu.startDate == null) return "";
    return "${edu.startDate!.year} - ${edu.endDate?.year ?? 'Present'}";
  }
}
