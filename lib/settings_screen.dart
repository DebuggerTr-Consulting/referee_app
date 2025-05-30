import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(t.editProfile),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.profileEditClicked)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t.logout),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AuthScreen(onLocaleChange: onLocaleChange),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
