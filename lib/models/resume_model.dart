
import 'package:hive/hive.dart';
import 'dart:convert';

part 'resume_model.g.dart';

@HiveType(typeId: 0)
class ResumeModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final PersonalDetails personalDetails;
  @HiveField(3)
  final String summary;
  @HiveField(4)
  final List<Experience> experience;
  @HiveField(5)
  final List<Education> education;
  @HiveField(6)
  final List<String> skills;
  @HiveField(7)
  final List<Project> projects;
  @HiveField(8)
  final List<Certification> certifications;
  @HiveField(9)
  final DateTime lastModified;

  ResumeModel({
    required this.id,
    this.title = 'My Resume',
    required this.personalDetails,
    this.summary = '',
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.projects = const [],
    this.certifications = const [],
    DateTime? lastModified,
  }) : this.lastModified = lastModified ?? DateTime.now();

  ResumeModel copyWith({
    String? id,
    String? title,
    PersonalDetails? personalDetails,
    String? summary,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
    List<Project>? projects,
    List<Certification>? certifications,
    DateTime? lastModified,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      personalDetails: personalDetails ?? this.personalDetails,
      summary: summary ?? this.summary,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      lastModified: lastModified ?? DateTime.now(),
    );
  }

  factory ResumeModel.empty() {
    return ResumeModel(
      id: DateTime.now().toIso8601String(),
      personalDetails: PersonalDetails.empty(),
    );
  }
}

@HiveType(typeId: 1)
class PersonalDetails {
  @HiveField(0)
  final String fullName;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String? linkedinUrl;
  @HiveField(5)
  final String? portfolioUrl;
  @HiveField(6)
  final String? imagePath;

  PersonalDetails({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedinUrl,
    this.portfolioUrl,
    this.imagePath,
  });

  factory PersonalDetails.empty() {
    return PersonalDetails(
      fullName: '',
      email: '',
      phone: '',
      location: '',
    );
  }

  PersonalDetails copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? linkedinUrl,
    String? portfolioUrl,
    String? imagePath,
  }) {
    return PersonalDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

@HiveType(typeId: 2)
class Experience {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String jobTitle;
  @HiveField(2)
  final String company;
  @HiveField(3)
  final DateTime? startDate;
  @HiveField(4)
  final DateTime? endDate;
  @HiveField(5)
  final bool isCurrent;
  @HiveField(6)
  final String description;

  Experience({
    required this.id,
    required this.jobTitle,
    required this.company,
    this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description = '',
  });
}

@HiveType(typeId: 3)
class Education {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String degree;
  @HiveField(2)
  final String institution;
  @HiveField(3)
  final DateTime? startDate;
  @HiveField(4)
  final DateTime? endDate;
  @HiveField(5)
  final String description;

  Education({
    required this.id,
    required this.degree,
    required this.institution,
    this.startDate,
    this.endDate,
    this.description = '',
  });
}

@HiveType(typeId: 4)
class Project {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String? url;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.url,
  });
}

@HiveType(typeId: 5)
class Certification {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String authority;
  @HiveField(3)
  final DateTime? date;

  Certification({
    required this.id,
    required this.title,
    required this.authority,
    this.date,
  });
}
