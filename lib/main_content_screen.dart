import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'Strings/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainContentScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const MainContentScreen({super.key, required this.onLocaleChange});

  @override
  State<MainContentScreen> createState() => MainContentScreenState();
}

class MainContentScreenState extends State<MainContentScreen> {
  final _auth = FirebaseAuth.instance;

  bool isExpanded = false;

  void _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthScreen(onLocaleChange: widget.onLocaleChange),
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SettingsScreen(onSignOut: () => _signOut(context)),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isExpanded ? 200 : 80,
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _toggleMenu,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null ? const Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(height: 20),
                if (isExpanded)
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: Text(t.settings, style: const TextStyle(color: Colors.white)),
                    onTap: _navigateToSettings,
                  ),
                // if (isExpanded)
                //   ListTile(
                //     leading: const Icon(Icons.logout, color: Colors.white),
                //     title: Text(t.logout, style: const TextStyle(color: Colors.white)),
                //     onTap: () => _signOut(context),
                //   ),
                const Spacer(),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => widget.onLocaleChange(const Locale('tr')),
                            child: const Text(AppStrings.tr),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => widget.onLocaleChange(const Locale('en')),
                            child: const Text(AppStrings.en),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(title: Text(t.welcome)),
                Expanded(
                  child: Center(child: Text(t.mainContent)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   final user = _auth.currentUser;
  //   final t = AppLocalizations.of(context)!;
  //   return Scaffold(
  //     body: Row(
  //       children: [
  //         AnimatedContainer(
  //           duration: Duration(milliseconds: 300),
  //           width: isExpanded ? 200 : 80,
  //           color: Colors.blueGrey[900],
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 40),
  //               GestureDetector(
  //                 onTap: _toggleMenu,
  //                 child: CircleAvatar(
  //                   radius: 30,
  //                   backgroundImage:
  //                       user?.photoURL != null
  //                           ? NetworkImage(user!.photoURL!)
  //                           : null,
  //                   child: user?.photoURL == null ? Icon(Icons.person) : null,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               if (isExpanded)
  //                 ListTile(
  //                   leading: Icon(Icons.settings, color: Colors.white),
  //                   title: Text(
  //                     t.settings,
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   onTap: _navigateToSettings,
  //                 ),
  //               Spacer(),
  //               if (isExpanded)
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 16.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           widget.onLocaleChange(Locale('tr'));
  //                           Navigator.pushReplacement(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder:
  //                                   (_) => MainContentScreen(
  //                                     onLocaleChange: widget.onLocaleChange,
  //                                   ),
  //                             ),
  //                           );
  //                         },
  //                         child: Text(
  //                           AppStrings.tr,
  //                           style: TextStyle(
  //                             color: const Color.fromARGB(255, 0, 0, 0),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           widget.onLocaleChange(Locale('en'));
  //                           Navigator.pushReplacement(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder:
  //                                   (_) => MainContentScreen(
  //                                     onLocaleChange: widget.onLocaleChange,
  //                                   ),
  //                             ),
  //                           );
  //                         },
  //                         child: Text(
  //                           AppStrings.en,
  //                           style: TextStyle(
  //                             color: const Color.fromARGB(255, 1, 0, 0),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Column(
  //             children: [
  //               AppBar(title: Text(t.welcome)),
  //               Expanded(child: Center(child: Text(t.mainContent))),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


class SettingsScreen extends StatelessWidget {
  final VoidCallback onSignOut;
  const SettingsScreen({Key? key, required this.onSignOut}) : super(key: key);
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
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
