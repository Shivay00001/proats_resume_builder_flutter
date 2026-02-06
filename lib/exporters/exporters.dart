
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/resume_model.dart';

class TxtExporter {
  static String generate(ResumeModel resume) {
    final buffer = StringBuffer();
    
    buffer.writeln(resume.personalDetails.fullName.toUpperCase());
    buffer.writeln("-" * resume.personalDetails.fullName.length);
    buffer.writeln("Location: ${resume.personalDetails.location}");
    buffer.writeln("Email: ${resume.personalDetails.email}");
    buffer.writeln("Phone: ${resume.personalDetails.phone}");
    if (resume.personalDetails.linkedinUrl != null) buffer.writeln("LinkedIn: ${resume.personalDetails.linkedinUrl}");
    buffer.writeln("");
    
    if (resume.summary.isNotEmpty) {
      buffer.writeln("PROFESSIONAL SUMMARY");
      buffer.writeln("-" * 20);
      buffer.writeln(resume.summary);
      buffer.writeln("");
    }
    
    if (resume.experience.isNotEmpty) {
      buffer.writeln("WORK EXPERIENCE");
      buffer.writeln("-" * 20);
      for (final exp in resume.experience) {
        buffer.writeln("${exp.jobTitle} at ${exp.company}");
        String dateLine = "";
        if (exp.startDate != null) {
          dateLine += "${exp.startDate!.year}";
          if (exp.endDate != null) dateLine += " - ${exp.endDate!.year}";
          else if (exp.isCurrent) dateLine += " - Present";
        }
        buffer.writeln(dateLine);
        buffer.writeln(exp.description);
        buffer.writeln("");
      }
    }
    
    if (resume.education.isNotEmpty) {
      buffer.writeln("EDUCATION");
      buffer.writeln("-" * 20);
      for (final edu in resume.education) {
        buffer.writeln("${edu.institution}");
        buffer.writeln("${edu.degree}");
         String dateLine = "";
        if (edu.startDate != null) {
          dateLine += "${edu.startDate!.year}";
          if (edu.endDate != null) dateLine += " - ${edu.endDate!.year}";
        }
        buffer.writeln(dateLine);
        buffer.writeln("");
      }
    }
    
    if (resume.skills.isNotEmpty) {
      buffer.writeln("SKILLS");
      buffer.writeln("-" * 20);
      buffer.writeln(resume.skills.join(", "));
      buffer.writeln("");
    }
    
    return buffer.toString();
  }
}

class DocxExporter {
  // A very basic DOCX generator that creates a valid zip structure with minimal XML.
  static List<int> generate(ResumeModel resume) {
    final archive = Archive();
    
    // [Content_Types].xml
    archive.addFile(ArchiveFile('[Content_Types].xml', _contentTypes.length, utf8.encode(_contentTypes)));
    
    // _rels/.rels
    archive.addFile(ArchiveFile('_rels/.rels', _rels.length, utf8.encode(_rels)));
    
    // word/_rels/document.xml.rels
    archive.addFile(ArchiveFile('word/_rels/document.xml.rels', _documentRels.length, utf8.encode(_documentRels)));
    
    // word/document.xml - The actual content
    final documentXml = _buildDocumentXml(resume);
    archive.addFile(ArchiveFile('word/document.xml', documentXml.length, utf8.encode(documentXml)));

    return ZipEncoder().encode(archive)!;
  }

  static String _buildDocumentXml(ResumeModel resume) {
    final sb = StringBuffer();
    sb.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    sb.write('<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">');
    sb.write('<w:body>');
    
    // Title
    _addParagraph(sb, resume.personalDetails.fullName.toUpperCase(), bold: true, size: 28, align: 'center');
    _addParagraph(sb, "${resume.personalDetails.location} | ${resume.personalDetails.email} | ${resume.personalDetails.phone}", size: 20, align: 'center');
    if (resume.personalDetails.linkedinUrl != null) {
      _addParagraph(sb, resume.personalDetails.linkedinUrl!, size: 20, align: 'center');
    }
    
    // Summary
    if (resume.summary.isNotEmpty) {
       _addHeader(sb, "PROFESSIONAL SUMMARY");
       _addParagraph(sb, resume.summary);
    }
    
    // Experience
    if (resume.experience.isNotEmpty) {
      _addHeader(sb, "WORK EXPERIENCE");
      for (final exp in resume.experience) {
        _addParagraph(sb, "${exp.jobTitle} - ${exp.company}", bold: true);
         String dateStr = "";
         if (exp.startDate != null) dateStr = "${exp.startDate!.year} - ${exp.isCurrent ? 'Present' : exp.endDate?.year ?? ''}";
        _addParagraph(sb, dateStr, italic: true);
        _addParagraph(sb, exp.description);
        _addEmptyLine(sb);
      }
    }
    
    // Education
    if (resume.education.isNotEmpty) {
      _addHeader(sb, "EDUCATION");
      for (final edu in resume.education) {
        _addParagraph(sb, "${edu.institution}", bold: true);
        _addParagraph(sb, "${edu.degree}");
         String dateStr = "";
         if (edu.startDate != null) dateStr = "${edu.startDate!.year} - ${edu.endDate?.year ?? ''}";
        _addParagraph(sb, dateStr, italic: true);
        _addEmptyLine(sb);
      }
    }
    
    // Skills
    if (resume.skills.isNotEmpty) {
      _addHeader(sb, "SKILLS");
      _addParagraph(sb, resume.skills.join(", "));
    }

    sb.write('<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/></w:sectPr>');
    sb.write('</w:body></w:document>');
    return sb.toString();
  }
  
  static void _addHeader(StringBuffer sb, String text) {
    sb.write('<w:p><w:pPr><w:spacing w:before="240" w:after="120"/><w:jc w:val="left"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="24"/></w:rPr><w:t>${_escape(text)}</w:t></w:r></w:p>');
  }

  static void _addParagraph(StringBuffer sb, String text, {bool bold = false, bool italic = false, int size = 22, String align = 'left'}) {
    // 22 half-points = 11pt font
    sb.write('<w:p><w:pPr><w:jc w:val="$align"/></w:pPr><w:r><w:rPr>');
    if (bold) sb.write('<w:b/>');
    if (italic) sb.write('<w:i/>');
    sb.write('<w:sz w:val="$size"/>');
    sb.write('</w:rPr><w:t>${_escape(text)}</w:t></w:r></w:p>');
  }
  
  static void _addEmptyLine(StringBuffer sb) {
     sb.write('<w:p/>');
  }

  static String _escape(String text) {
    return text.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&apos;');
  }

  static const String _contentTypes = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>';
  
  static const String _rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>';
  
  static const String _documentRels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"></Relationships>';
}
