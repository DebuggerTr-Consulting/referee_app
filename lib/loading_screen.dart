import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_screen.dart';
import 'main_content_screen.dart';

class LoadingScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  final bool isLoggedIn;

  const LoadingScreen({super.key, required this.onLocaleChange, required this.isLoggedIn});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (widget.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainContentScreen(onLocaleChange: widget.onLocaleChange),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthScreen(onLocaleChange: widget.onLocaleChange),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'lib/assets/logo.png',
          height: 200,
        ),
      ),
    );
  }
}
