import 'package:flutter/material.dart';
import '../data/student_repository.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key});

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final _addressLine1 = TextEditingController();
  final _addressLine2 = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _policeStationController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await StudentRepository().fetchStudentData();
    if (!mounted) return;
    setState(() {
      // Support common key variants
      _addressLine1.text = (data?['address_line1'] ?? data?['address1'] ?? data?['address'] ?? '').toString();
      _addressLine2.text = (data?['address_line2'] ?? data?['address2'] ?? '').toString();
      _postOfficeController.text = (data?['post_office'] ?? data?['postoffice'] ?? data?['po'] ?? '').toString();
      _policeStationController.text = (data?['police_station'] ?? data?['policestation'] ?? data?['ps'] ?? '').toString();
      _cityController.text = (data?['city'] ?? '').toString();
      _districtController.text = (data?['district'] ?? data?['dist'] ?? '').toString();
      _stateController.text = (data?['state'] ?? data?['province'] ?? data?['region'] ?? '').toString();
      _pincodeController.text = (data?['pincode'] ?? data?['postal_code'] ?? data?['zip'] ?? '').toString();
      _countryController.text = (data?['country'] ?? '').toString();
      _loading = false;
    });
  }

  @override
  void dispose() {
    _addressLine1.dispose();
    _addressLine2.dispose();
    _postOfficeController.dispose();
    _policeStationController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Address Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Address Line 1
                TextField(controller: _addressLine1, decoration: const InputDecoration(labelText: 'Address Line 1')),
                const SizedBox(height: 12),
                // 2. Address Line 2
                TextField(controller: _addressLine2, decoration: const InputDecoration(labelText: 'Address Line 2')),
                const SizedBox(height: 12),
                // 3. PostOffice
                TextField(controller: _postOfficeController, decoration: const InputDecoration(labelText: 'Post Office')),
                const SizedBox(height: 12),
                // 4. Police Station
                TextField(controller: _policeStationController, decoration: const InputDecoration(labelText: 'Police Station')),
                const SizedBox(height: 12),
                // 5. City
                TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
                const SizedBox(height: 12),
                // 6. District
                TextField(controller: _districtController, decoration: const InputDecoration(labelText: 'District')),
                const SizedBox(height: 12),
                // 7. State
                TextField(controller: _stateController, decoration: const InputDecoration(labelText: 'State')),
                const SizedBox(height: 12),
                // 8. Pincode
                TextField(controller: _pincodeController, decoration: const InputDecoration(labelText: 'Pincode')),
                const SizedBox(height: 12),
                // 9. Country
                TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country')),
              ],
            ),
    );
  }
}
