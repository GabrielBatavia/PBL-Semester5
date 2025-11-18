// lib/widgets/dashboard_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📊 Kegiatan per Kategori",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.4,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: colorScheme.primary,
                    title: 'Sosial\n40%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: AppTheme.primaryOrange,
                    title: 'Keagamaan\n30%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: const Color(0xFF6A11CB),
                    title: 'Pendidikan\n20%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: const Color(0xFF16A34A),
                    title: 'Olahraga\n10%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: const [
              _LegendDot(
                color: Color(0xFF2563EB),
                label: 'Komunitas & Sosial',
              ),
              _LegendDot(
                color: AppTheme.primaryOrange,
                label: 'Keagamaan',
              ),
              _LegendDot(
                color: Color(0xFF6A11CB),
                label: 'Pendidikan',
              ),
              _LegendDot(
                color: Color(0xFF16A34A),
                label: 'Kesehatan & Olahraga',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

