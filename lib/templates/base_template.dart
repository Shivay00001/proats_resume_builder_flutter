
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/resume_model.dart';
import 'classic.dart';
import 'minimal.dart';
import 'modern.dart';
import 'executive.dart';

abstract class ResumeTemplate {
  String get name;
  String get id;
  
  // The main build function that returns a PDF Document
  Future<pw.Document> buildPdf(ResumeModel resume);
  
  static List<ResumeTemplate> getAll() {
    return [
      ClassicTemplate(),
      MinimalTemplate(),
      ModernTemplate(),
      ExecutiveTemplate(),
    ];
  }
}

// Helpers for common ATS styles
class AtsStyles {
  // ATS Text Styles (Serif/Sans-Serif standard fonts)
  static pw.TextStyle headerStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18);
  static pw.TextStyle sectionHeaderStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14);
  static pw.TextStyle bodyStyle = const pw.TextStyle(fontSize: 10); // Standard readable size
  
  static pw.PageTheme getPageTheme({double margin = 40}) {
    return pw.PageTheme(
      margin: pw.EdgeInsets.all(margin),
      pageFormat: PdfPageFormat.a4,
    );
  }
}
