import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:referee_aplication/main_content_screen.dart';

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(t.editProfile),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(t.profileEditClicked)));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(t.logout),
            onTap: widget.onSignOut,
          ),
        ],
      ),
    );
  }
}
