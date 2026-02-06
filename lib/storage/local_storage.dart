
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/resume_model.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _resumeBoxName = 'resumes';

  Future<void> init() async {
    // Initialize Hive
    // Note: Hive.initFlutter() is called in main.dart usually, 
    // but we can ensure adapters are registered here or in main.
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(ResumeModelAdapter());
       Hive.registerAdapter(PersonalDetailsAdapter());
       Hive.registerAdapter(ExperienceAdapter());
       Hive.registerAdapter(EducationAdapter());
       Hive.registerAdapter(ProjectAdapter());
       Hive.registerAdapter(CertificationAdapter());
    }

    await Hive.openBox<ResumeModel>(_resumeBoxName);
  }

  Box<ResumeModel> get _box => Hive.box<ResumeModel>(_resumeBoxName);

  Future<void> saveResume(ResumeModel resume) async {
    await _box.put(resume.id, resume);
  }

  ResumeModel? getResume(String id) {
    return _box.get(id);
  }

  // For MVP, we might just have one active resume, or a list.
  // This gets the most recently modified one, or creates a new one.
  Future<ResumeModel> getLatestOrNew() async {
    if (_box.isEmpty) {
      final newResume = ResumeModel.empty();
      await saveResume(newResume);
      return newResume;
    }
    
    final list = _box.values.toList();
    list.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return list.first;
  }
  
  Future<void> deleteResume(String id) async {
    await _box.delete(id);
  }
}
