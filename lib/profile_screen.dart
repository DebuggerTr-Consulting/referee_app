import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';
import '/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const ProfileScreen({super.key, required this.onLocaleChange});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String birthDate = "";
  String startRefDate = "";
  String city = "";
  String country = "";
  String gender = "";
  bool isLoading = true;

  final List<Map<String, dynamic>> leagues = [
    {"name": "Süper Lig", "logo": Icons.sports_soccer, "matches": 32},
    {"name": "TFF 1. Lig", "logo": Icons.sports, "matches": 21},
    {"name": "UEFA", "logo": Icons.public, "matches": 12},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          name = data['name'] ?? "";
          birthDate = data['birthDate'] ?? "";
          startRefDate = data['startRefDate'] ?? "";
          city = data['city'] ?? "";
          country = data['country'] ?? "";
          gender = data['gender'] ?? "";
          isLoading = false;
        });
      }
    }
  }

  String getLocalizedGender(AppLocalizations t, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return t.genderMale;
      case 'female':
        return t.genderFemale;
      case 'other':
        return t.genderOthers;
      default:
        return gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          SettingsScreen(onLocaleChange: widget.onLocaleChange),
                ),
              ).then((_) => fetchUserData());
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("${t.birthDate}: $birthDate"),
                    Text("${t.refereeStartDate}: $startRefDate"),
                    Text("${t.location}: $city, $country"),
                    Text("${t.gender}: ${getLocalizedGender(t, gender)}"),
                    const Divider(height: 40),
                    Text(
                      t.leaguesParticipated,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          leagues.map((league) {
                            return Column(
                              children: [
                                Icon(league["logo"], size: 40),
                                const SizedBox(height: 4),
                                Text("${league["matches"]} ${t.matches}"),
                              ],
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
    );
  }
}
