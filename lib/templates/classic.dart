
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_model.dart';
import 'base_template.dart';

class ClassicTemplate extends ResumeTemplate {
  @override
  String get name => "Classic Corporate";
  @override
  String get id => "classic";

  @override
  Future<pw.Document> buildPdf(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: AtsStyles.getPageTheme(),
        build: (context) => [
          _buildHeader(resume),
          pw.Divider(), 
          if (resume.summary.isNotEmpty) ...[
            _buildSectionTitle("PROFESSIONAL SUMMARY"),
            pw.Text(resume.summary, style: AtsStyles.bodyStyle),
            pw.SizedBox(height: 10),
          ],
          if (resume.experience.isNotEmpty) ...[
            _buildSectionTitle("WORK EXPERIENCE"),
            ...resume.experience.map((e) => _buildExperienceItem(e)),
            pw.SizedBox(height: 10),
          ],
          if (resume.education.isNotEmpty) ...[
            _buildSectionTitle("EDUCATION"),
            ...resume.education.map((e) => _buildEducationItem(e)),
            pw.SizedBox(height: 10),
          ],
          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle("SKILLS"),
            pw.Bullet(text: resume.skills.join(", "), style: AtsStyles.bodyStyle),
          ],
        ],
      ),
    );
    return pdf;
  }

  pw.Widget _buildHeader(ResumeModel resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(resume.personalDetails.fullName.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
        pw.SizedBox(height: 4),
        pw.Text(
          [
            resume.personalDetails.location,
            resume.personalDetails.phone,
            resume.personalDetails.email
          ].where((e) => e.isNotEmpty).join(" | "),
          style: const pw.TextStyle(fontSize: 10),
        ),
        if (resume.personalDetails.linkedinUrl != null)
           pw.Text(resume.personalDetails.linkedinUrl!, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
      child: pw.Text(title, style: AtsStyles.sectionHeaderStyle),
    );
  }

  pw.Widget _buildExperienceItem(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(exp.company, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(_formatDate(exp.startDate, exp.endDate, exp.isCurrent), style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Text(exp.jobTitle, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10)),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, top: 2),
            child: pw.Text(exp.description, style: AtsStyles.bodyStyle),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education edu) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.Text(_formatDate(edu.startDate, edu.endDate, false), style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime? start, DateTime? end, bool isCurrent) {
    if (start == null) return "";
    final startStr = "${start.year}";
    if (isCurrent) return "$startStr - Present";
    if (end == null) return startStr;
    return "$startStr - ${end.year}";
  }
}
