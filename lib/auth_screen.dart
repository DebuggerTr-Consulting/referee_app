import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_content_screen.dart';
import '/l10n/app_localizations.dart';
import 'shared/language_constants.dart';

class AuthScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const AuthScreen({super.key, required this.onLocaleChange});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isSignInMode = true;
  String _selectedLanguageCode = 'en';

  Future<void> _signInWithEmailAndPassword() async {
    setState(() => _errorMessage = '');
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _navigateToMainContent();
    } catch (e) {
      setState(() => _errorMessage = 'Login failed');
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    setState(() => _errorMessage = '');
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await Future.delayed(Duration(milliseconds: 100));
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': '',
          'birthDate': '',
          'startRefDate': '',
          'city': '',
          'country': '',
        });
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _navigateToMainContent();
    } catch (e) {
      setState(() => _errorMessage = 'Sign Up failed');
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _errorMessage = '');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _errorMessage = 'Google Sign-In cancelled.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      final user = _auth.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': '',
            'birthDate': '',
            'startRefDate': '',
            'city': '',
            'country': '',
            'gender': '',
          });
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _navigateToMainContent();
    } catch (e) {
      setState(() => _errorMessage = 'Google Sign-In failed.');
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _errorMessage = '');

    if (Platform.isIOS || Platform.isMacOS) {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final appleProviderCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        await _auth.signInWithCredential(appleProviderCredential);

        final user = _auth.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'name': '',
              'birthDate': '',
              'startRefDate': '',
              'city': '',
              'country': '',
              'gender': '',
            });
          }
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        _navigateToMainContent();
      } catch (e) {
        setState(() => _errorMessage = 'Apple Sign-In failed.');
      }
    } else {
      setState(() => _errorMessage = 'Apple Sign-In is only available on Apple devices.');
    }
  }

  void _navigateToMainContent() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainContentScreen(onLocaleChange: widget.onLocaleChange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(_isSignInMode ? t.login : t.signUp)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedLanguageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguageCode = newValue;
                  });
                  widget.onLocaleChange(Locale(newValue));
                }
              },
              items: (languageList
                    ..sort((a, b) => a['label']!.compareTo(b['label']!)))
                  .map(
                    (lang) => DropdownMenuItem<String>(
                      value: lang['code'],
                      child: Text('${lang['emoji']} ${lang['label']}'),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: t.email),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: t.password),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSignInMode ? _signInWithEmailAndPassword : _signUpWithEmailAndPassword,
              child: Text(_isSignInMode ? t.login : t.signUp),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignInMode = !_isSignInMode),
              child: Text(_isSignInMode ? t.needAccount : t.haveAccount),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            if (Platform.isAndroid) ...[
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text(t.signInWithGoogle),
              ),
              const SizedBox(height: 10),
            ],
            if (Platform.isIOS) ...[
              ElevatedButton(
                onPressed: _signInWithApple,
                child: Text(t.signInWithApple),
              ),
              const SizedBox(height: 10),
            ],
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
