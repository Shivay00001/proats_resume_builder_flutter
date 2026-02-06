
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_model.dart';
import '../storage/local_storage.dart';

// The state is the current active ResumeModel being edited.
class ResumeNotifier extends StateNotifier<ResumeModel> {
  final StorageService _storage;

  ResumeNotifier(this._storage) : super(ResumeModel.empty()) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final resume = await _storage.getLatestOrNew();
    state = resume;
  }

  Future<void> updatePersonalDetails(PersonalDetails details) async {
    state = state.copyWith(personalDetails: details);
    await _save();
  }

  Future<void> updateSummary(String summary) async {
    state = state.copyWith(summary: summary);
    await _save();
  }

  Future<void> addExperience(Experience exp) async {
    state = state.copyWith(experience: [...state.experience, exp]);
    await _save();
  }

  Future<void> updateExperience(Experience exp) async {
    final newExp = state.experience.map((e) => e.id == exp.id ? exp : e).toList();
    state = state.copyWith(experience: newExp);
    await _save();
  }
  
  Future<void> reorderExperience(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.experience.removeAt(oldIndex);
    state.experience.insert(newIndex, item);
    // Trigger copyWith to notify listeners, though list mutation on state directly is bad practice,
    // so we should reconstruct.
    state = state.copyWith(experience: [...state.experience]);
    await _save();
  }

  Future<void> removeExperience(String id) async {
    state = state.copyWith(
      experience: state.experience.where((e) => e.id != id).toList(),
    );
    await _save();
  }

  // Generic generic update for skills
  Future<void> updateSkills(List<String> skills) async {
    state = state.copyWith(skills: skills);
    await _save();
  }
  
  // Education, etc. follow similar patterns.
  Future<void> updateEducation(List<Education> eduList) async {
    state = state.copyWith(education: eduList);
    await _save();
  }

  Future<void> _save() async {
    state = state.copyWith(lastModified: DateTime.now());
    await _storage.saveResume(state);
  }
}

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeModel>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ResumeNotifier(storage);
});
