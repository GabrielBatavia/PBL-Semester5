// lib/widgets/dashboard_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // pastikan fl_chart sudah ada di pubspec

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // contoh data statis (bisa nanti di-connect ke API)
    final sections = <PieChartSectionData>[
      PieChartSectionData(
        value: 30,
        title: 'Keagamaan\n30%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: const Color(0xFF7C3AED),
      ),
      PieChartSectionData(
        value: 20,
        title: 'Pendidikan\n20%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: const Color(0xFF4F46E5),
      ),
      PieChartSectionData(
        value: 10,
        title: 'Olahraga\n10%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: const Color(0xFF22C55E),
      ),
      PieChartSectionData(
        value: 40,
        title: 'Sosial\n40%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: const Color(0xFF9333EA),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            children: [
              Icon(Icons.bar_chart, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Kegiatan per Kategori',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ⭕ donut chart – tinggi fixed supaya ratio konsisten
          SizedBox(
            height: 220,
            width: double.infinity,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 48,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
