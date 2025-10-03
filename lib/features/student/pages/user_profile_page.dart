import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../data/student_repository.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _professionController = TextEditingController();
  final _emailController = TextEditingController();

  String _gender = 'Male';
  String _age = '18 Years';
  bool _loading = true;
  // Picked avatar preview (web uses bytes, mobile can use file path)
  XFile? _pickedImage;
  Uint8List? _pickedBytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _showImageSourceSheet() async {
    final cs = Theme.of(context).colorScheme;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text('Files'),
                subtitle: const Text('Pick an image from files'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickFromFiles();
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: cs.error),
                    onPressed: () {
                      setState(() {
                        _pickedImage = null;
                        _pickedBytes = null;
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Remove photo'),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
      if (img == null) return;
      if (kIsWeb) {
        final bytes = await img.readAsBytes();
        setState(() {
          _pickedBytes = bytes;
          _pickedImage = img;
        });
      } else {
        setState(() => _pickedImage = img);
      }
    } catch (e) {
      _showError('Failed to open camera: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
      if (img == null) return;
      if (kIsWeb) {
        final bytes = await img.readAsBytes();
        setState(() {
          _pickedBytes = bytes;
          _pickedImage = img;
        });
      } else {
        setState(() => _pickedImage = img);
      }
    } catch (e) {
      _showError('Failed to pick from gallery: $e');
    }
  }

  Future<void> _pickFromFiles() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (res == null || res.files.isEmpty) return;
      final file = res.files.single;
      if (file.bytes != null) {
        setState(() {
          _pickedBytes = file.bytes;
          _pickedImage = null;
        });
      } else if (file.path != null && !kIsWeb) {
        // On mobile/desktop, we can keep a pseudo XFile via path
        setState(() {
          _pickedImage = XFile(file.path!);
          _pickedBytes = null;
        });
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _load() async {
    final repo = StudentRepository();
    final parts = await repo.fetchStudentNameParts();
    final data = await repo.fetchStudentData();
    final supa = Supabase.instance.client.auth.currentUser;
    if (!mounted) return;
    setState(() {
      final name = [parts.firstName, parts.middleName, parts.lastName]
          .where((s) => s.trim().isNotEmpty)
          .join(' ');
      _nameController.text = name;
      _dobController.text = (data?['date_of_birth'] ?? data?['dob'] ?? '').toString();
      _professionController.text = (data?['profession'] ?? data?['job_title'] ?? '').toString();
      _emailController.text = (data?['email'] ?? supa?.email ?? '').toString();
      final g = (data?['gender'] ?? '').toString().toLowerCase();
      if (g == 'female') _gender = 'Female';
      if (g == 'other') _gender = 'Other';
      final ageNum = (data?['age'] ?? '').toString();
      if (ageNum.isNotEmpty) _age = '$ageNum Years';
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _professionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    DateTime? initial;
    try {
      initial = _dobController.text.trim().isEmpty
          ? null
          : DateTime.tryParse(_dobController.text.trim());
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
      setState(() => _dobController.text = '$y-$m-$d');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: cs.primaryContainer,
                        backgroundImage: _pickedBytes != null
                            ? MemoryImage(_pickedBytes!)
                            : (_pickedImage != null && !kIsWeb)
                                ? FileImage(File(_pickedImage!.path))
                                : null,
                        child: (_pickedBytes == null && _pickedImage == null)
                            ? Icon(Icons.person, color: cs.onPrimaryContainer, size: 40)
                            : null,
                      ),
                      Material(
                        color: cs.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _showImageSourceSheet,
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.edit, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Your Name', style: text.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Full name'),
                ),
                const SizedBox(height: 16),
                Text('Date of Birth', style: text.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: 'YYYY-MM-DD', suffixIcon: Icon(Icons.calendar_today)),
                  onTap: _pickDob,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender', style: text.labelLarge),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            items: const [
                              DropdownMenuItem(value: 'Male', child: Text('Male')),
                              DropdownMenuItem(value: 'Female', child: Text('Female')),
                              DropdownMenuItem(value: 'Other', child: Text('Other')),
                            ],
                            onChanged: (v) => setState(() => _gender = v ?? _gender),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age', style: text.labelLarge),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _age,
                            items: List<String>.generate(83, (i) => '${i + 18} Years')
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => setState(() => _age = v ?? _age),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Your Profession', style: text.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _professionController,
                  decoration: const InputDecoration(hintText: 'e.g., Student'),
                ),
                const SizedBox(height: 16),
                Text('Email', style: text.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'email@example.com'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved (demo)')),
                      );
                    },
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
    );
  }
}
