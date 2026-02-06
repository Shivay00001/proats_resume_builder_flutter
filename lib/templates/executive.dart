
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_model.dart';
import 'base_template.dart';

class ExecutiveTemplate extends ResumeTemplate {
  @override
  String get name => "Executive Simple";
  @override
  String get id => "executive";

  @override
  Future<pw.Document> buildPdf(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: AtsStyles.getPageTheme(),
        build: (context) => [
          pw.Center(
             child: pw.Text(resume.personalDetails.fullName.toUpperCase(), 
             style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 22, letterSpacing: 2))
          ),
          pw.Center(
             child: pw.Text(resume.personalDetails.location, style: const pw.TextStyle(fontSize: 10))
          ),
          pw.SizedBox(height: 4),
          pw.Center(child: pw.Text([resume.personalDetails.email, resume.personalDetails.phone].join(" | "), style: const pw.TextStyle(fontSize: 10))),
          
          pw.Divider(), 

          if (resume.summary.isNotEmpty) ...[
             pw.SizedBox(height: 10),
             pw.Text(resume.summary, style: AtsStyles.bodyStyle, textAlign: pw.TextAlign.justify),
          ],
          
          if (resume.experience.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text("PROFESSIONAL EXPERIENCE", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
           ...resume.experience.map((e) => _item(e)),
          ],
          
          if (resume.education.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text("EDUCATION", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
            ...resume.education.map((e) => _itemEdu(e)),
          ],
          
          if (resume.skills.isNotEmpty) ...[
             pw.SizedBox(height: 20),
             pw.Text("CORE COMPETENCIES", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
             pw.SizedBox(height: 5),
             pw.Text(resume.skills.join(" • "), style: AtsStyles.bodyStyle),
          ]
        ],
      ),
    );
    return pdf;
  }
  
  pw.Widget _item(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
           pw.Text(exp.company.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
           pw.Text(exp.isCurrent ? "Present" : (exp.endDate?.year.toString() ?? ""), style: const pw.TextStyle(fontSize: 10)),
        ]),
        pw.Text(exp.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        pw.SizedBox(height: 2),
        pw.Text(exp.description, style: AtsStyles.bodyStyle),
      ])
    );
  }
  
  pw.Widget _itemEdu(Education edu) {
     return pw.Container(
       margin: const pw.EdgeInsets.only(bottom: 6),
       child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
         pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
         pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
       ])
     );
  }
}
