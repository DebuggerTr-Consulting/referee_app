import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Add this import
import 'dart:io' show Platform; // To check the platform for Apple Sign-In

import 'main_content_screen.dart'; // Import your main screen

ElevatedButton googleButton(BuildContext context, VoidCallback onPressed) {
  return ElevatedButton.icon(
    icon: Image.asset('lib/assets/ios_neutral_sq_na@2x.png', height: 24),
    label: const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Text('Sign in with Google', style: TextStyle(fontSize: 18)),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    onPressed: onPressed,
  );
}

Widget appleSignInButton(VoidCallback onPressed) {
  return SignInWithAppleButton(
    onPressed: onPressed,
    height: 48,
    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isSignInMode = true; // State variable to toggle between Sign In and Sign Up

  // --- Email/Password Methods ---

  Future<void> _signInWithEmailAndPassword() async {
    setState(() { _errorMessage = ''; }); // Clear previous errors
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // If successful, navigate to the main content
      _navigateToMainContent();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _handleUnexpectedError(e, "signing in with email/password");
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
     setState(() { _errorMessage = ''; }); // Clear previous errors
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
       // Optional: Send email verification after sign-up
       await _auth.currentUser?.sendEmailVerification();
       // Show a message asking the user to check their email

      // If successful, navigate to the main content (or a verification waiting screen)
      _navigateToMainContent();
    } on FirebaseAuthException catch (e) {
       _handleAuthError(e);
    } catch (e) {
      _handleUnexpectedError(e, "signing up with email/password");
    }
  }


  // --- Google Sign-In Method ---

  Future<void> _signInWithGoogle() async {
     setState(() { _errorMessage = ''; }); // Clear previous errors
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Abort if the user canceled the sign-in process
      if (googleUser == null) {
         setState(() { _errorMessage = "Google Sign-In cancelled."; });
         return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      await _auth.signInWithCredential(credential);

      // If successful, navigate to the main content
      _navigateToMainContent();

    } on FirebaseAuthException catch (e) {
       _handleAuthError(e);
    } catch (e) {
       _handleUnexpectedError(e, "signing in with Google");
    }
  }
     // --- Apple Sign-In Method ---

  Future<void> _signInWithApple() async {
  setState(() { _errorMessage = ''; });

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
      _navigateToMainContent();

    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        setState(() { _errorMessage = ""; });
      } else {
        setState(() {
          _errorMessage = "Apple Sign-In failed: ${e.code}";
        });
      }
    } catch (e) {
      _handleUnexpectedError(e, "signing in with Apple");
    }
  } else {
    setState(() {
      _errorMessage = "Sign in with Apple is only available on Apple devices.";
    });
  }
}


  // --- Helper Methods ---

   void _handleAuthError(FirebaseAuthException e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
         case 'email-already-in-use':
           message = 'This email address is already in use.';
           break;
         case 'operation-not-allowed':
            message = 'Email/Password sign-in is not enabled.'; // Should be enabled if we're using it!
            break;
         case 'weak-password':
            message = 'The password is too weak.';
            break;
        default:
          message = 'An unexpected error occurred: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
      debugPrint("FirebaseAuthException: ${e.code}"); // Log the code for debugging
   }

   void _handleUnexpectedError(dynamic e, String action) {
        setState(() {
           _errorMessage = "An unexpected error occurred while $action.";
        });
        debugPrint("Unexpected error during $action: $e"); // Log the full error
   }


void _navigateToMainContent() {
  if (!mounted) return; // <-- bunu ekle
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return; // burada da eklemek faydalı olur
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainContentScreen()),
    );
  });
}

  void _toggleAuthMode() {
    setState(() {
      _isSignInMode = !_isSignInMode; // Switch between sign in and sign up
      _errorMessage = ''; // Clear error message when switching modes
    });
     // Optional: Clear text fields when switching modes
     _emailController.clear();
     _passwordController.clear();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignInMode ? 'Sign In' : 'Sign Up')),
      body: Center( // Wrap with Center to keep content centered
        child: SingleChildScrollView( // Allows scrolling if content is too long
          padding: const EdgeInsets.all(24.0), // Increased padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons horizontally
            children: <Widget>[
              // Add your app logo or a welcome message here if desired
              Image.asset(
                 'lib/assets/logo.png', // Optional: another logo for auth screen
                 height: 100,
              ),
               SizedBox(height: 40), // Add some space

              // --- Email/Password Fields ---
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                   border: OutlineInputBorder(), // Add border for better appearance
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),

              // --- Email/Password Sign In/Sign Up Button ---
              ElevatedButton(
                onPressed: _isSignInMode ? _signInWithEmailAndPassword : _signUpWithEmailAndPassword,
                child: Padding( // Add padding to button text
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                     _isSignInMode ? 'Sign In' : 'Sign Up',
                     style: TextStyle(fontSize: 18),
                    ),
                ),
              ),

              SizedBox(height: 16.0),

              // --- Toggle Button ---
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(
                  _isSignInMode ? 'Need an account? Sign Up' : 'Have an account? Sign In',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 32.0), // More space before social buttons

              // --- Separator ---
              Row(
                 children: <Widget>[
                   Expanded(child: Divider()), // Horizontal line
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: Text('OR'),
                   ),
                   Expanded(child: Divider()),
                 ],
              ),

              SizedBox(height: 32.0), // Space after separator

              // --- Social Sign-In Buttons ---

             if (Platform.isAndroid)
              googleButton(context, _signInWithGoogle),

            if (Platform.isIOS)
              appleSignInButton(_signInWithApple),

            const SizedBox(height: 24.0),

            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),


              // ElevatedButton.icon(
              //    icon: Image.asset('lib/assets/ios_neutral_sq_na@2x.png', height: 24), // Use your Google logo asset
              //    label: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 12.0),
              //       child: Text(
              //          'Sign in with Google',
              //          style: TextStyle(fontSize: 18),
              //          ),
              //    ),
              //    style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.white, // White background for Google button
              //       foregroundColor: Colors.black87, // Dark text
              //       shape: RoundedRectangleBorder(
              //          borderRadius: BorderRadius.circular(4.0), // Match Google style
              //          side: BorderSide(color: Colors.grey.shade300), // Add a light border
              //       )
              //    ),
              //    onPressed: _signInWithGoogle,
              // ),

              // // Only show Apple Sign-In button on iOS
              // if (Platform.isIOS) ...[
              //    SizedBox(height: 16.0),
              //    SignInWithAppleButton(
              //      onPressed: _signInWithApple,
              //      height: 48, // Standard height
              //      borderRadius: const BorderRadius.all(Radius.circular(4.0)), // Match styling
              //    ),
              // ],

              // SizedBox(height: 24.0), // Space before error message

              // // --- Error Message Display ---
              // if (_errorMessage.isNotEmpty) // Only show if there's an error
              //    Text(
              //       _errorMessage,
              //       style: TextStyle(color: Colors.red, fontSize: 14),
              //       textAlign: TextAlign.center, // Center the error text
              //    ),

            ],
          ),
        ),
      ),
    );
  }
}
