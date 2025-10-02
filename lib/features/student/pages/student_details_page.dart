import 'package:flutter/material.dart';
import '../data/student_repository.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final _studentIdController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _universityRollController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _streamController = TextEditingController();
  final _mentorController = TextEditingController();
  final _currentYearController = TextEditingController();
  final _currentSemesterController = TextEditingController();
  final _dateOfAdmissionController = TextEditingController();
  final _startingYearController = TextEditingController();
  final _finalYearController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = StudentRepository();
    final data = await repo.fetchStudentData();
    if (!mounted) return;
    setState(() {
      _studentIdController.text = (data?['student_id'] ?? '').toString();
      _registrationIdController.text = (data?['registration_id'] ?? data?['reg_id'] ?? data?['registrationId'] ?? '').toString();
      _universityRollController.text = (data?['university_roll_number'] ?? data?['university_roll_no'] ?? data?['university_roll'] ?? data?['uni_roll'] ?? '').toString();
      _rollNoController.text = (data?['roll_no'] ?? data?['rollno'] ?? data?['roll'] ?? '').toString();
      // Department/Stream
      _departmentController.text = (data?['department'] ?? data?['dept'] ?? data?['department_name'] ?? '').toString();
      _streamController.text = (data?['stream'] ?? data?['branch'] ?? '').toString();
      // Mentor (supports advisor variants)
      _mentorController.text = (data?['mentor'] ?? data?['advisor'] ?? data?['mantor'] ?? data?['adviser'] ?? '').toString();
      // Year/Semester
      _currentYearController.text = (data?['current_year'] ?? data?['year'] ?? data?['present_year'] ?? '').toString();
      _currentSemesterController.text = (data?['current_semester'] ?? data?['semester'] ?? data?['sem'] ?? '').toString();
      // Admission/Years
      _dateOfAdmissionController.text = (data?['date_of_admission'] ?? data?['admission_date'] ?? data?['doa'] ?? '').toString();
      _startingYearController.text = (data?['starting_year'] ?? data?['start_year'] ?? '').toString();
      _finalYearController.text = (data?['final_year'] ?? data?['end_year'] ?? data?['passout_year'] ?? '').toString();
      _loading = false;
    });
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _registrationIdController.dispose();
    _universityRollController.dispose();
    _rollNoController.dispose();
    _departmentController.dispose();
    _streamController.dispose();
    _mentorController.dispose();
    _currentYearController.dispose();
    _currentSemesterController.dispose();
    _dateOfAdmissionController.dispose();
    _startingYearController.dispose();
    _finalYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Student Information')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Student Id
                TextField(controller: _studentIdController, decoration: const InputDecoration(labelText: 'Student Id')),
                const SizedBox(height: 12),
                // 2. Registration Id
                TextField(controller: _registrationIdController, decoration: const InputDecoration(labelText: 'Registration Id')),
                const SizedBox(height: 12),
                // 3. University Roll Number
                TextField(controller: _universityRollController, decoration: const InputDecoration(labelText: 'University Roll Number')),
                const SizedBox(height: 12),
                // 4. Roll no.
                TextField(controller: _rollNoController, decoration: const InputDecoration(labelText: 'Roll no.')),
                const SizedBox(height: 12),
                // 5. Department
                TextField(controller: _departmentController, decoration: const InputDecoration(labelText: 'Department')),
                const SizedBox(height: 12),
                // 6. Stream
                TextField(controller: _streamController, decoration: const InputDecoration(labelText: 'Stream')),
                const SizedBox(height: 12),
                // 7. Mentor
                TextField(controller: _mentorController, decoration: const InputDecoration(labelText: 'Mentor')),
                const SizedBox(height: 12),
                // Additional Information (collapsible)
                ExpansionTile(
                  title: const Text('Additional Information'),
                  children: [
                    const SizedBox(height: 4),
                    // 8. Current year
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(controller: _currentYearController, decoration: const InputDecoration(labelText: 'Current Year')),
                    ),
                    const SizedBox(height: 12),
                    // 9. Current semester
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(controller: _currentSemesterController, decoration: const InputDecoration(labelText: 'Current Semester')),
                    ),
                    const SizedBox(height: 12),
                    // 10. Date of Admission
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _dateOfAdmissionController,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Date of Admission (YYYY-MM-DD)'),
                        onTap: () async {
                          final now = DateTime.now();
                          DateTime? initial;
                          try {
                            initial = _dateOfAdmissionController.text.trim().isEmpty
                                ? null
                                : DateTime.tryParse(_dateOfAdmissionController.text.trim());
                          } catch (_) {}
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initial ?? DateTime(now.year - 1, now.month, now.day),
                            firstDate: DateTime(1950, 1, 1),
                            lastDate: DateTime(now.year + 1, 12, 31),
                          );
                          if (picked != null) {
                            final y = picked.year.toString().padLeft(4, '0');
                            final m = picked.month.toString().padLeft(2, '0');
                            final d = picked.day.toString().padLeft(2, '0');
                            _dateOfAdmissionController.text = '$y-$m-$d';
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 11. Starting Year
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(controller: _startingYearController, decoration: const InputDecoration(labelText: 'Starting Year')),
                    ),
                    const SizedBox(height: 12),
                    // 12. Final Year
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(controller: _finalYearController, decoration: const InputDecoration(labelText: 'Final Year')),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
    );
  }
}
