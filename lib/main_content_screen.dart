import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'profile_screen.dart';

class MainContentScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const MainContentScreen({super.key, required this.onLocaleChange});

  @override
  State<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final List<Widget> _pages = [
      Center(child: Text(t.home)), // Translated home label
      Center(child: Text(t.calendar)),
      Center(child: Text(t.search)),
      ProfileScreen(onLocaleChange: widget.onLocaleChange),
    ];

    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: t.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: t.calendar,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: t.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: t.profile,
          ),
        ],
      ),
    );
  }
}
