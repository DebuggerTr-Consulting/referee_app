import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'Strings/strings.dart';

class MainContentScreen extends StatefulWidget {
  const MainContentScreen({Key? key}) : super(key: key);

  @override
  MainContentScreenState createState() => MainContentScreenState();
}

class MainContentScreenState extends State<MainContentScreen> {
  final _auth = FirebaseAuth.instance;
  bool isExpanded = false;

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  void _toggleMenu() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsScreen(onSignOut: () => _signOut(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isExpanded ? 200 : 80,
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _toggleMenu,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null ? Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(height: 20),
                if (isExpanded)
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text(AppStrings.settings, style: TextStyle(color: Colors.white)),
                    onTap: _navigateToSettings,
                  ),
                Spacer(),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.tr, style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10),
                        Text(AppStrings.en, style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(AppStrings.welcome),
                ),
                Expanded(
                  child: Center(
                    child: Text(AppStrings.mainContent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final VoidCallback onSignOut;

  const SettingsScreen({Key? key, required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(AppStrings.editProfile),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.profileEditClicked)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppStrings.logout),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_screen.dart'; // Import your auth screen for signing out

// class MainContentScreen extends StatefulWidget {
//   const MainContentScreen({Key? key}) : super(key: key);

//   @override
//   _MainContentScreenState createState() => _MainContentScreenState();
// }

// class _MainContentScreenState extends State<MainContentScreen> {
//   final _auth = FirebaseAuth.instance;
//   bool isExpanded = false;

//   void _signOut(BuildContext context) async {
//     await _auth.signOut();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => AuthScreen()),
//     );
//   }

//   void _toggleMenu() {
//     setState(() {
//       isExpanded = !isExpanded;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;

//     return Scaffold(
//       body: Row(
//         children: [
//           AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             width: isExpanded ? 200 : 80,
//             color: Colors.blueGrey[900],
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 GestureDetector(
//                   onTap: _toggleMenu,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: user?.photoURL != null
//                         ? NetworkImage(user!.photoURL!)
//                         : null,
//                     child: user?.photoURL == null ? Icon(Icons.person) : null,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (isExpanded)
//                   ListTile(
//                     leading: Icon(Icons.settings, color: Colors.white),
//                     title: Text('Ayarlar', style: TextStyle(color: Colors.white)),
//                     onTap: () {},
//                   ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 AppBar(
//                   title: Text('Welcome!'),
//                   actions: [
//                     IconButton(
//                       icon: Icon(Icons.logout),
//                       tooltip: 'Sign Out',
//                       onPressed: () => _signOut(context),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text('Main Content Goes Here'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_screen.dart'; // Import your auth screen for signing out

// // ignore: use_key_in_widget_constructors
// class MainContentScreen extends StatelessWidget {
//   final _auth = FirebaseAuth.instance;

  

//   void _signOut(BuildContext context) async {
//     await _auth.signOut();
//     // Navigate back to the authentication screen after signing out
//     // ignore: use_build_context_synchronously
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => AuthScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get the current user to display their info (optional)
//     final user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome!'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             tooltip: 'Sign Out',
//             onPressed: () => _signOut(context), // Call sign out function
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You are logged in!',
//               style: TextStyle(fontSize: 24),
//             ),
//             if (user != null) // Display user info if available
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('User ID: ${user.uid}'),
//               ),
//             // Add the rest of your app's main content here
//           ],
//         ),
//       ),
//     );
//   }
// }
