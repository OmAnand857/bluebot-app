import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'calibrate_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 1; // Home is in center

  final List<Widget> _pages = const [
    CalibrateScreen(),
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // allows body behind bottom bar
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.toggleRight),
              label: "calibrate",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.home),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.settings),
              label: "settings",
            ),
          ],
        ),
      ),
    );
  }
}
