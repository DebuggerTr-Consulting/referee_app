import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:referee_aplication/firebase_options.dart';
// Import the firebase_app_check plugin
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/language_constants.dart';

// Replace with your actual main screen file
// Replace with your actual authentication screen file
import 'loading_screen.dart'; // We'll create this splash/loading screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by Firebase.initializeApp

  try {
    debugPrint("Initializing Firebase...");
    await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions
              .currentPlatform, // Uncomment if you used the CLI
    );
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
    // Handle the error - maybe show an alert to the user
  }

  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
  debugPrint("Firebase App Check activated successfully.");

  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('language');
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final systemLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final locale = savedLang != null
      ? Locale(savedLang)
      : ['en', 'tr', 'lv'].contains(systemLang) ? Locale(systemLang) : const Locale('en');

  runApp(MyApp(startLocale: locale, isLoggedIn: isLoggedIn));

  // runApp( MyApp());
}

class MyApp extends StatefulWidget {
  final Locale startLocale;
  final bool isLoggedIn;

  const MyApp({super.key, required this.startLocale, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_null_comparison, prefer_if_null_operators
    _locale = widget.startLocale != null
        ? widget.startLocale
        : const Locale('en'); // Default to English if no locale is set
    debugPrint("App started with locale: ${_locale.languageCode}");
  }

  void setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      // supportedLocales: const [Locale('en'), Locale('tr')],
      supportedLocales: supportedLocaleList,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Referee Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 26, 222),
        ),
      ),
      home: LoadingScreen(
        onLocaleChange: setLocale,
        isLoggedIn: widget.isLoggedIn,
      ),
    );
  }
}

