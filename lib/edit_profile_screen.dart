import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _startRefDateController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _smsCodeController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _birthDateController.text = data['birthDate'] ?? '';
        _startRefDateController.text = data['startRefDate'] ?? '';
        _cityController.text = data['city'] ?? '';
        _countryController.text = data['country'] ?? '';
        _selectedGender = data['gender'];
      }
      setState(() {});
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      _isChanged = true;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'birthDate': _birthDateController.text,
          'startRefDate': _startRefDateController.text,
          'city': _cityController.text,
          'country': _countryController.text,
          'gender': _selectedGender,
        }, SetOptions(merge: true));
      }
      setState(() => _isLoading = false);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_isChanged,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _isChanged) {
          final shouldDiscard = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.warning),
              content: Text(t.unsavedChanges),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(t.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(t.discard),
                ),
              ],
            ),
          );

          // ignore: use_build_context_synchronously
          if (shouldDiscard == true && mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.editProfile)),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_nameController.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: t.name),
                        validator: (value) => value!.isEmpty ? t.requiredField : null,
                        onChanged: (_) => _isChanged = true,
                      ),
                      TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        decoration: InputDecoration(labelText: t.birthDate),
                        onTap: () => _selectDate(_birthDateController),
                      ),
                      TextFormField(
                        controller: _startRefDateController,
                        readOnly: true,
                        decoration: InputDecoration(labelText: t.refereeStartDate),
                        onTap: () => _selectDate(_startRefDateController),
                      ),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(labelText: t.city),
                        onChanged: (_) => _isChanged = true,
                      ),
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(labelText: t.country),
                        onChanged: (_) => _isChanged = true,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(labelText: t.gender),
                        items: [
                          DropdownMenuItem(value: 'male', child: Text(t.genderMale)),
                          DropdownMenuItem(value: 'female', child: Text(t.genderFemale)),
                          DropdownMenuItem(value: 'other', child: Text(t.genderOthers)),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                          _isChanged = true;
                        },
                        validator: (value) => value == null ? t.requiredField : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: _saveProfile, child: Text(t.save)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _startRefDateController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }
}
