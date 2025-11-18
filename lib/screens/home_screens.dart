// lib/screens/home_screens.dart
import 'package:flutter/material.dart';
import '../theme/AppTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text("Beranda")),
    Center(child: Text("Pencarian")),
    Center(child: Text("Profil")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: _pages[_selectedIndex]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.96),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryOrange,
            unselectedItemColor: Colors.grey[500],
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                label: 'Cari',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
