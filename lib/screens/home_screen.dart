
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'form_steps/personal_screen.dart';
import 'form_steps/summary_screen.dart';
import 'form_steps/experience_screen.dart';
import 'form_steps/education_screen.dart';
import 'form_steps/skills_screen.dart';
import 'preview_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<Widget> _steps = [
    const PersonalDetailsScreen(), // Step 0
    const SummaryScreen(),         // Step 1
    const ExperienceScreen(),      // Step 2
    const EducationScreen(),       // Step 3
    const SkillsScreen(),          // Step 4
    // Add Projects/Certifications later if needed
  ];
  
  // Titles for the steps
  final List<String> _stepTitles = [
    "Personal info",
    "Summary",
    "Experience",
    "Education",
    "Skills",
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    } else {
      // Go to Preview
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewScreen()));
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume Builder - Step ${_currentStep + 1} of ${_steps.length}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: "Live Preview",
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: StepProgressIndicator(
              totalSteps: _steps.length,
              currentStep: _currentStep + 1,
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _stepTitles[_currentStep],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: _steps,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               if (_currentStep > 0)
                ElevatedButton.icon(
                  onPressed: _prevStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                )
              else
                const SizedBox(width: 80), // Spacer
              
              ElevatedButton.icon(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward),
                label: Text(_currentStep == _steps.length - 1 ? "Finish" : "Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
