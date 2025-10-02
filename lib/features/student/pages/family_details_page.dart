import 'package:flutter/material.dart';
import '../data/student_repository.dart';

class FamilyDetailsPage extends StatefulWidget {
  const FamilyDetailsPage({super.key});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  final _motherNameController = TextEditingController();
  final _motherNumberController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherNumberController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _contactController = TextEditingController();
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
      // Mother
      _motherNameController.text = (data?['mother_name'] ?? data?['mother'] ?? data?['mom_name'] ?? '').toString();
      _motherNumberController.text = (data?['mother_number'] ?? data?['mother_phone'] ?? data?['mother_mobile'] ?? data?['mom_number'] ?? data?['mother_contact'] ?? '').toString();
      // Father
      _fatherNameController.text = (data?['father_name'] ?? data?['father'] ?? data?['dad_name'] ?? '').toString();
      _fatherNumberController.text = (data?['father_number'] ?? data?['father_phone'] ?? data?['father_mobile'] ?? data?['dad_number'] ?? data?['father_contact'] ?? '').toString();
      // Guardian
      _guardianNameController.text = (data?['guardian_name'] ?? data?['guardian'] ?? '').toString();
      _relationshipController.text = (data?['guardian_relationship'] ?? data?['relationship'] ?? '').toString();
      _contactController.text = (data?['guardian_contact'] ?? data?['contact_number'] ?? data?['guardian_phone'] ?? '').toString();
      _loading = false;
    });
  }

  @override
  void dispose() {
    _motherNameController.dispose();
    _motherNumberController.dispose();
    _fatherNameController.dispose();
    _fatherNumberController.dispose();
    _guardianNameController.dispose();
    _relationshipController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Family Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Mother Name
                TextField(controller: _motherNameController, decoration: const InputDecoration(labelText: 'Mother Name')),
                const SizedBox(height: 12),
                // 2. Mother Number
                TextField(
                  controller: _motherNumberController,
                  decoration: const InputDecoration(labelText: 'Mother Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                // 3. Father Name
                TextField(controller: _fatherNameController, decoration: const InputDecoration(labelText: 'Father Name')),
                const SizedBox(height: 12),
                // 4. Father Number
                TextField(
                  controller: _fatherNumberController,
                  decoration: const InputDecoration(labelText: 'Father Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                // 5. Guardian Name
                TextField(controller: _guardianNameController, decoration: const InputDecoration(labelText: 'Guardian Name')),
                const SizedBox(height: 12),
                // 6. Relationship
                TextField(controller: _relationshipController, decoration: const InputDecoration(labelText: 'Relationship')),
                const SizedBox(height: 12),
                // 7. Contact Number
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
    );
  }
}
