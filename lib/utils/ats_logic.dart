
import '../models/resume_model.dart';

class AtsCheckResult {
  final int score;
  final List<String> warnings;
  final List<String> improvements;

  AtsCheckResult({
    required this.score,
    required this.warnings,
    required this.improvements,
  });
}

class AtsLogic {
  static AtsCheckResult analyze(ResumeModel resume) {
    int score = 100;
    List<String> warnings = [];
    List<String> improvements = [];

    // 1. Critical Sections Check
    if (resume.summary.isEmpty) {
      score -= 10;
      warnings.add("Missing Professional Summary.");
    } else if (resume.summary.length < 100) {
      score -= 5;
      improvements.add("Professional Summary is too short. Aim for 3-4 sentences.");
    }

    if (resume.experience.isEmpty) {
      score -= 20;
      warnings.add("No Work Experience found. This is critical for ATS.");
    }

    if (resume.education.isEmpty) {
      score -= 10;
      warnings.add("No Education section found.");
    }

    if (resume.skills.isEmpty) {
      score -= 15;
      warnings.add("No Skills found. ATS relies heavily on keyword matching.");
    } else if (resume.skills.length < 5) {
      score -= 5;
      improvements.add("Add more skills. 8-12 core skills is recommended.");
    }

    // 2. Content Formatting Check
    for (var exp in resume.experience) {
      if (exp.description.isEmpty) {
        score -= 5;
        warnings.add("Empty description for role: ${exp.jobTitle}");
      } else if (!exp.description.contains('•') && !exp.description.contains('-') && !exp.description.contains('\n')) {
        // Simple check for bullet points or lists
        improvements.add("Role '${exp.jobTitle}' description might be a wall of text. Use bullet points.");
      }
    }

    // 3. Contact Info
    if (resume.personalDetails.email.isEmpty) {
      score -= 20; // Critical
      warnings.add("Missing Email Address.");
    }
    if (resume.personalDetails.phone.isEmpty) {
      score -= 10;
      warnings.add("Missing Phone Number.");
    }
    if (resume.personalDetails.location.isEmpty) {
      score -= 5;
      improvements.add("Location is missing. Recruiters often filter by location.");
    }

    // 4. Length Check (Rough estimation: 3000 chars ~ 1 page dense, 6000 ~ 2 pages)
    // We treat > 6000 as potential risk for entry/mid level
    final totalLen = resume.summary.length + 
        resume.experience.fold(0, (sum, e) => sum + e.description.length) +
        resume.education.length * 100;
        
    if (totalLen > 6000) {
      improvements.add("Resume might be too long (> 2 pages). Keep it concise.");
    } else if (totalLen < 500) {
      score -= 10;
      warnings.add("Resume is extremely sparse. Add more detail.");
    }

    return AtsCheckResult(
      score: score.clamp(0, 100),
      warnings: warnings,
      improvements: improvements,
    );
  }
}
