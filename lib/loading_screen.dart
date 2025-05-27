// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'main_content_screen.dart'; // Your main app screen
// import 'auth_screen.dart'; // Your authentication screen

// class LoadingScreen extends StatelessWidget {
//   const LoadingScreen({super.key});

//   // This Future will complete when the auth state is determined
//   Future<User?> _checkAuthState() async {
//     // A small delay can be added here if you want the logo to show for
//     // a minimum duration, but it's often better handled by the splash *image* config itself
//     // or by allowing the FutureBuilder to manage the async timing.
//     // await Future.delayed(Duration(seconds: 2)); // Optional: force a minimum show time

//     return FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder<User?>(
//           future: _checkAuthState(), // Check the auth state
//           builder: (context, snapshot) {
//             // While we are checking (connectionState is waiting) or if there's an error,
//             // show the logo or a loading indicator.
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               // Show your logo here!
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset( 
//                     'lib/assets/logo.png', // Replace with the path to your logo image
//                     width: 150, // Adjust size as needed
//                     height: 150, // Adjust size as needed
//                   ),
//                   SizedBox(height: 20),
//                   CircularProgressIndicator(), // Optional: show a loader below the logo
//                 ],
//               );
//             }

//             // If the Future is complete, determine where to navigate
//             // snapshot.data will be the User object if logged in, or null if not
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//                if (snapshot.data != null) {
//                  // User is logged in, navigate to the main content
//                  Navigator.of(context).pushReplacement(
//                    MaterialPageRoute(builder: (context) => MainContentScreen()),
//                  );
//                } else {
//                  // No user is logged in, navigate to the authentication screen
//                  Navigator.of(context).pushReplacement(
//                    MaterialPageRoute(builder: (context) => AuthScreen()),
//                  );
//                }
//             });


//             // We still show the loading state while the navigation happens
//             // This return is technically only reached if the post-frame callback hasn't
//             // triggered navigation yet, but it's good practice.
//              return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'lib/assets/logo.png', // Replace with the path to your logo image
//                     width: 150, // Adjust size as needed
//                     height: 150, // Adjust size as needed
//                   ),
//                   SizedBox(height: 20),
//                   CircularProgressIndicator(), // Optional: show a loader below the logo
//                 ],
//               );


//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';

import 'auth_screen.dart'; // Loading sonrası yönlenecek ekran

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
