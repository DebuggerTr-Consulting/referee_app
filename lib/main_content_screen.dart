import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart'; // Import your auth screen for signing out

// ignore: use_key_in_widget_constructors
class MainContentScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    // Navigate back to the authentication screen after signing out
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user to display their info (optional)
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => _signOut(context), // Call sign out function
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are logged in!',
              style: TextStyle(fontSize: 24),
            ),
            if (user != null) // Display user info if available
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('User ID: ${user.uid}'),
              ),
            // Add the rest of your app's main content here
          ],
        ),
      ),
    );
  }
}
