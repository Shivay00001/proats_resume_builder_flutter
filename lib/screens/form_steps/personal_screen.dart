
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/resume_provider.dart';
import '../../models/resume_model.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _linkedinController;
  late TextEditingController _portfolioController;

  @override
  void initState() {
    super.initState();
    // Initialize with current state
    final details = ref.read(resumeProvider).personalDetails;
    _nameController = TextEditingController(text: details.fullName);
    _emailController = TextEditingController(text: details.email);
    _phoneController = TextEditingController(text: details.phone);
    _locationController = TextEditingController(text: details.location);
    _linkedinController = TextEditingController(text: details.linkedinUrl);
    _portfolioController = TextEditingController(text: details.portfolioUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newDetails = PersonalDetails(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
        linkedinUrl: _linkedinController.text.isNotEmpty ? _linkedinController.text : null,
        portfolioUrl: _portfolioController.text.isNotEmpty ? _portfolioController.text : null,
      );
      ref.read(resumeProvider.notifier).updatePersonalDetails(newDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider mainly to rebuild if external changes happen? 
    // Ideally we just save locally.
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        onChanged: _save, // Auto-save on change
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Basic Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v!.isEmpty ? "Name is required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty ? "Email is required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? "Phone is required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Location (City, Country)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (v) => v!.isEmpty ? "Location is required" : null,
            ),
            const SizedBox(height: 24),
            const Text("Links (Optional)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkedinController,
              decoration: const InputDecoration(
                labelText: "LinkedIn URL",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _portfolioController,
              decoration: const InputDecoration(
                labelText: "Portfolio URL",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
