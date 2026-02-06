// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeModelAdapter extends TypeAdapter<ResumeModel> {
  @override
  final int typeId = 0;

  @override
  ResumeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResumeModel(
      id: fields[0] as String,
      title: fields[1] as String,
      personalDetails: fields[2] as PersonalDetails,
      summary: fields[3] as String,
      experience: (fields[4] as List).cast<Experience>(),
      education: (fields[5] as List).cast<Education>(),
      skills: (fields[6] as List).cast<String>(),
      projects: (fields[7] as List).cast<Project>(),
      certifications: (fields[8] as List).cast<Certification>(),
      lastModified: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ResumeModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.personalDetails)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.experience)
      ..writeByte(5)
      ..write(obj.education)
      ..writeByte(6)
      ..write(obj.skills)
      ..writeByte(7)
      ..write(obj.projects)
      ..writeByte(8)
      ..write(obj.certifications)
      ..writeByte(9)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalDetailsAdapter extends TypeAdapter<PersonalDetails> {
  @override
  final int typeId = 1;

  @override
  PersonalDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalDetails(
      fullName: fields[0] as String,
      email: fields[1] as String,
      phone: fields[2] as String,
      location: fields[3] as String,
      linkedinUrl: fields[4] as String?,
      portfolioUrl: fields[5] as String?,
      imagePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalDetails obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.linkedinUrl)
      ..writeByte(5)
      ..write(obj.portfolioUrl)
      ..writeByte(6)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExperienceAdapter extends TypeAdapter<Experience> {
  @override
  final int typeId = 2;

  @override
  Experience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Experience(
      id: fields[0] as String,
      jobTitle: fields[1] as String,
      company: fields[2] as String,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      isCurrent: fields[5] as bool,
      description: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Experience obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobTitle)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isCurrent)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 3;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      id: fields[0] as String,
      degree: fields[1] as String,
      institution: fields[2] as String,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.institution)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 4;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      url: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CertificationAdapter extends TypeAdapter<Certification> {
  @override
  final int typeId = 5;

  @override
  Certification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Certification(
      id: fields[0] as String,
      title: fields[1] as String,
      authority: fields[2] as String,
      date: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Certification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authority)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
