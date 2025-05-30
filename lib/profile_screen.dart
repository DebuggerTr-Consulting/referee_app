import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  final String name = "Mustafa Yılmaz";
  final String birthDate = "01.01.1987";
  final String startRefDate = "02.11.2008";
  final String city = "İstanbul";
  final String country = "Türkiye";

  final List<Map<String, dynamic>> leagues = [
    {"name": "Süper Lig", "logo": Icons.sports_soccer, "matches": 32},
    {"name": "TFF 1. Lig", "logo": Icons.sports, "matches": 21},
    {"name": "UEFA", "logo": Icons.public, "matches": 12},
  ];

  ProfileScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(onLocaleChange: onLocaleChange),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("${t.birthDate}: $birthDate"),
            Text("${t.refereeStartDate}: $startRefDate"),
            Text("${t.location}: $city, $country"),
            const Divider(height: 40),
            Text(t.leaguesParticipated, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: leagues.map((league) {
                return Column(
                  children: [
                    Icon(league["logo"], size: 40),
                    const SizedBox(height: 4),
                    Text("${league["matches"]} ${t.matches}"),
                  ],
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
