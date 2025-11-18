// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/dashboard_chart.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_statistik.dart';
import '../widgets/kegiatan_section.dart';
import '../widgets/log_aktivitas_section.dart';
import '../widgets/bottom_navbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
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
        child: SafeArea(
          child: Stack(
            children: [
              // 🔹 Konten utama dashboard
              SingleChildScrollView(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8),
                    DashboardHeader(),
                    SizedBox(height: 16),
                    DashboardStatistik(),
                    SizedBox(height: 24),
                    DashboardChart(),
                    SizedBox(height: 24),
                    KegiatanSection(),
                    SizedBox(height: 24),
                    LogAktivitasSection(),
                  ],
                ),
              ),

              // 🔹 Bottom Navigation mengambang
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const BottomNavbar(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
