// lib/widgets/dashboard_chart.dart
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';
import 'package:jawaramobile_1/services/activitiy_service.dart';
import 'package:fl_chart/fl_chart.dart'; // pastikan fl_chart sudah ada di pubspec

class DashboardChart extends StatefulWidget {
  const DashboardChart({super.key});

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  List<ActivityCategoryStats> _stats = [];
  bool _isLoading = true;

  // Category colors mapping
  final Map<String, Color> _categoryColors = {
    'kebersihan': const Color(0xFF2563EB),
    'keagamaan': AppTheme.primaryOrange,
    'pendidikan': const Color(0xFF6A11CB),
    'olahraga': const Color(0xFF16A34A),
    'keamanan': const Color(0xFFDC2626),
    'sosial': const Color(0xFF7C3AED),
    'rapat': const Color(0xFFEAB308),
    'kegiatan': const Color(0xFF06B6D4),
  };

  // Category display names
  final Map<String, String> _categoryNames = {
    'kebersihan': 'Kebersihan',
    'keagamaan': 'Keagamaan',
    'pendidikan': 'Pendidikan',
    'olahraga': 'Kesehatan & Olahraga',
    'keamanan': 'Keamanan',
    'sosial': 'Komunitas & Sosial',
    'rapat': 'Rapat',
    'kegiatan': 'Kegiatan Umum',
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    final stats = await ActivityService.getCategoryStats();
    
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  Color _getColorForCategory(String category, int index) {
    return _categoryColors[category.toLowerCase()] ?? 
           _getDefaultColor(index);
  }

  Color _getDefaultColor(int index) {
    final colors = [
      const Color(0xFF2563EB),
      AppTheme.primaryOrange,
      const Color(0xFF6A11CB),
      const Color(0xFF16A34A),
      const Color(0xFFDC2626),
      const Color(0xFF7C3AED),
      const Color(0xFFEAB308),
      const Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  String _getCategoryDisplayName(String category) {
    return _categoryNames[category.toLowerCase()] ?? category;
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "📊 Kegiatan per Kategori",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_stats.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Belum ada data kegiatan',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            AspectRatio(
              aspectRatio: 1.4,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sections: _stats.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    final color = _getColorForCategory(stat.category, index);
                    
                    return PieChartSectionData(
                      value: stat.percentage,
                      color: color,
                      title: '${_getCategoryDisplayName(stat.category)}\n${stat.percentage.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          
          if (_stats.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: _stats.asMap().entries.map((entry) {
                final index = entry.key;
                final stat = entry.value;
                final color = _getColorForCategory(stat.category, index);
                
                return _LegendDot(
                  color: color,
                  label: '${_getCategoryDisplayName(stat.category)} (${stat.count})',
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
