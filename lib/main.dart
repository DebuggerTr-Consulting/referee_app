import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:referee_aplication/firebase_options.dart';


// Replace with your actual main screen file
// Replace with your actual authentication screen file
import 'loading_screen.dart'; // We'll create this splash/loading screen

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized(); // Required by Firebase.initializeApp

  try {
    debugPrint("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Uncomment if you used the CLI
    );
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
    // Handle the error - maybe show an alert to the user
  }

  runApp( MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
 //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Referee Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 26, 222)),
      ),

      // Set the initial route to your loading screen
      home: LoadingScreen(), // This is where the magic starts

      // home: FutureBuilder( future: _initialization, builder: (context, snapshot ){
      //   if(snapshot.hasError){
      //     return Center(child:Text('beklenilmeyen hata olustu'));
      //   } else if (snapshot.hasData){
      //     return MyHomePage(title: 'Flutter Demo Home Page');
      //   } else {
      //     return Center(child:CircularProgressIndicator());
      //   }
      // } )
      
      
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}