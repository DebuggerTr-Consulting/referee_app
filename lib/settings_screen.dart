import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'edit_profile_screen.dart';
import 'shared/language_constants.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguageCode = 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    _selectedLanguageCode = locale.languageCode;
  }

  void _confirmSignOut() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(t.logout),
        content: Text(t.logoutConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AuthScreen(onLocaleChange: widget.onLocaleChange),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Text(t.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(t.editProfile),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(t.logout),
                  onTap: _confirmSignOut,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedLanguageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedLanguageCode = newValue);
                  widget.onLocaleChange(Locale(newValue));
                }
              },
              items: languageList
                  .map(
                    (lang) => DropdownMenuItem<String>(
                      value: lang['code'],
                      child: Text('${lang['emoji']} ${lang['label']}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
