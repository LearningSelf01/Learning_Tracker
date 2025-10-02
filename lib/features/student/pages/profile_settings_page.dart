import 'package:flutter/material.dart';
import '../data/student_repository.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _firstController = TextEditingController();
  final _middleController = TextEditingController();
  final _lastController = TextEditingController();
  final _dobController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = StudentRepository();
    final parts = await repo.fetchStudentNameParts();
    final data = await repo.fetchStudentData();
    if (!mounted) return;
    setState(() {
      _firstController.text = parts.firstName;
      _middleController.text = parts.middleName;
      _lastController.text = parts.lastName;
      // Prefill Date of Birth and Blood Group from student_data, supporting common key variants
      _dobController.text = (data?['date_of_birth'] ?? data?['dob'] ?? '').toString();
      _bloodGroupController.text = (data?['blood_group'] ?? data?['bloodgroup'] ?? data?['blood'] ?? '').toString();
      // Phone and Email with variants
      _phoneController.text = (data?['phone_number'] ?? data?['phone'] ?? data?['mobile'] ?? data?['contact_number'] ?? '').toString();
      _emailController.text = (data?['email'] ?? data?['email_id'] ?? data?['mail'] ?? '').toString();
      _loading = false;
    });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _middleController.dispose();
    _lastController.dispose();
    _dobController.dispose();
    _bloodGroupController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initials = () {
      final f = _firstController.text.trim();
      final m = _middleController.text.trim();
      final l = _lastController.text.trim();
      String s = '';
      if (f.isNotEmpty) s += f[0].toUpperCase();
      if (l.isNotEmpty) s += l[0].toUpperCase();
      if (s.isEmpty && m.isNotEmpty) s = m[0].toUpperCase();
      return s.isEmpty ? 'U' : s;
    }();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Profile Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _firstController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _middleController,
                  decoration: const InputDecoration(labelText: 'Middle Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lastController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 12),
                // 4. Date of Birth with a date picker
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  onTap: () async {
                    final now = DateTime.now();
                    DateTime? initial;
                    try {
                      initial = _dobController.text.trim().isEmpty ? null : DateTime.tryParse(_dobController.text.trim());
                    } catch (_) {}
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial ?? DateTime(now.year - 18, now.month, now.day),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: now,
                    );
                    if (picked != null) {
                      final y = picked.year.toString().padLeft(4, '0');
                      final m = picked.month.toString().padLeft(2, '0');
                      final d = picked.day.toString().padLeft(2, '0');
                      _dobController.text = '$y-$m-$d';
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 12),
                // 5. Phone Number
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                // 6. Email ID
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email ID'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                // 7. Blood Group
                TextField(
                  controller: _bloodGroupController,
                  decoration: const InputDecoration(labelText: 'Blood Group'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile saved (demo)')),
                    );
                  },
                  child: const Text('Save Changes'),
                )
              ],
            ),
    );
  }
}
