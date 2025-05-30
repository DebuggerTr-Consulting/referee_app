import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  File? _profileImage;
  bool _isLoading = false;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
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
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.editProfile)),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                            child:
                                _profileImage == null
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: t.name),
                        validator:
                            (value) => value!.isEmpty ? t.requiredField : null,
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
                        decoration: InputDecoration(
                          labelText: t.refereeStartDate,
                        ),
                        onTap: () => _selectDate(_startRefDateController),
                      ),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(labelText: t.city),
                      ),
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(labelText: t.country),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(labelText: t.gender),
                        items: [
                          DropdownMenuItem(value: 'male', child: Text(t.male)),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(t.female),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text(t.other),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => _selectedGender = value),
                        validator:
                            (value) => value == null ? t.requiredField : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: Text(t.save),
                      ),
                    ],
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
    super.dispose();
  }
}
