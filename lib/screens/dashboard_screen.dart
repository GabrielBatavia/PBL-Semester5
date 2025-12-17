// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/dashboard_chart.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_statistik.dart';
import '../widgets/kegiatan_section.dart';
import '../widgets/log_aktivitas_section.dart';
import '../widgets/bottom_navbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.instance.getCachedRoleName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data ?? 'warga';
        return _DashboardContent(role: role);
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final String role;

  const _DashboardContent({super.key, required this.role});

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
              // 🔹 Konten utama dashboard (PERSIS urutan lama)
              SingleChildScrollView(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    DashboardHeader(role: role),
                    const SizedBox(height: 16),
                    DashboardStatistik(role: role),
                    const SizedBox(height: 24),

                    // ✅ SELALU TAMPIL, semua role
                    const DashboardChart(),
                    const SizedBox(height: 24),
                    const KegiatanSection(),
                    const SizedBox(height: 24),
                    const LogAktivitasSection(),
                  ],
                ),
              ),

              // 🔹 Bottom Navigation mengambang (tidak diubah)
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
