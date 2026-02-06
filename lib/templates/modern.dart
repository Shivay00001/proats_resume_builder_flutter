
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/resume_model.dart';
import 'base_template.dart';

class ModernTemplate extends ResumeTemplate {
  @override
  String get name => "Modern Professional";
  @override
  String get id => "modern";

  @override
  Future<pw.Document> buildPdf(ResumeModel resume) async {
    final pdf = pw.Document();
    
    // Accent Color (Dark Blue)
    final accent = PdfColor.fromInt(0xFF2C3E50);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: AtsStyles.getPageTheme(),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(resume.personalDetails.fullName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24, color: accent)),
                  pw.Text(resume.personalDetails.location, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(resume.personalDetails.email, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(resume.personalDetails.phone, style: const pw.TextStyle(fontSize: 10)),
                  if (resume.personalDetails.linkedinUrl != null)
                    pw.Text(resume.personalDetails.linkedinUrl!, style: const pw.TextStyle(fontSize: 10)),
                ],
              )
            ]
          ),
          pw.SizedBox(height: 20),
           if (resume.summary.isNotEmpty)
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
               pw.Text("Summary", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accent)),
               pw.Text(resume.summary, style: AtsStyles.bodyStyle),
               pw.SizedBox(height: 10),
            ]),
            
          // Two column layout for Skills and Experience if needed, but keeping single column for rigid ATS safety usually better.
          // We will stick to single col for "Modern" but with better blocking.
          
           if (resume.experience.isNotEmpty) ...[
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: accent, width: 2))),
              child: pw.Text("Experience", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accent)),
            ),
            pw.SizedBox(height: 5),
            ...resume.experience.map((e) => _item(e)),
          ],
          
           if (resume.education.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: accent, width: 2))),
              child: pw.Text("Education", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accent)),
            ),
            pw.SizedBox(height: 5),
            ...resume.education.map((e) => _itemEdu(e)),
          ],
          
           if (resume.skills.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: accent, width: 2))),
              child: pw.Text("Skills", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accent)),
            ),
             pw.SizedBox(height: 5),
             pw.Wrap(
               spacing: 5,
               runSpacing: 5,
               children: resume.skills.map((s) => pw.Container(
                 padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                 decoration: pw.BoxDecoration(
                   border: pw.Border.all(color: PdfColors.grey400),
                   borderRadius: pw.BorderRadius.circular(4),
                 ),
                 child: pw.Text(s, style: const pw.TextStyle(fontSize: 9))
               )).toList()
             )
           ],
        ],
      ),
    );
    return pdf;
  }
  
  pw.Widget _item(Experience exp) {
     return pw.Padding(
       padding: const pw.EdgeInsets.only(bottom: 8),
       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
         pw.Text(exp.jobTitle.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
         pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
           pw.Text(exp.company, style: const pw.TextStyle(fontSize: 10)),
           pw.Text(exp.startDate?.year.toString() ?? "", style: const pw.TextStyle(fontSize: 10)),
         ]),
         pw.Text(exp.description, style: AtsStyles.bodyStyle),
       ])
     );
  }
   pw.Widget _itemEdu(Education edu) {
     return pw.Padding(
       padding: const pw.EdgeInsets.only(bottom: 5),
       child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
         pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
             pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
         ]),
         pw.Text(edu.startDate?.year.toString() ?? "", style: const pw.TextStyle(fontSize: 10)),
       ])
     );
  }
}
