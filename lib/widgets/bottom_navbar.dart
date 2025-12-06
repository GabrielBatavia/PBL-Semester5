// lib/widgets/bottom_navbar.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/widgets/menu_popup.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/laporan-bulanan-rw')) return 1;
    if (location.startsWith('/menu-popup')) return 2;
    if (location.startsWith('/pengguna')) return 3;
    return 0;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;

      case 1:
        // route laporan bulanan RW
        context.push('/laporan-bulanan-rw');
        break;

      case 2:
        showMenuPopUp(context);
        break;

      case 3:
        // route manajemen / pengguna
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = _calculateSelectedIndex(context);

    final items = const [
      {'icon': FontAwesomeIcons.house, 'label': 'Home'},
      {'icon': FontAwesomeIcons.fileLines, 'label': 'Laporan'},
      {'icon': FontAwesomeIcons.bars, 'label': 'Menu'},
      {'icon': FontAwesomeIcons.userGroup, 'label': 'Pengguna'},
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withOpacity(0.55),
          backgroundColor: colorScheme.surface,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: items
              .map(
                (e) => BottomNavigationBarItem(
                  icon: FaIcon(e['icon'] as IconData, size: 18),
                  label: e['label'] as String,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
