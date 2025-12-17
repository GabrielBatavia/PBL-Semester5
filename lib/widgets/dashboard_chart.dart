// lib/widgets/dashboard_chart.dart
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';
import 'package:jawaramobile_1/services/activity_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart({super.key});

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  Map<String, int> _categoryCount = {};
  bool _isLoading = true;
  String? _error;

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // ✅ Ambil stats langsung dari backend (lebih cepat & rapi)
      final stats = await ActivityService.getCategoryStats();

      final Map<String, int> counts = {
        for (final s in stats) s.category.toLowerCase(): s.count,
      };

      if (!mounted) return;
      setState(() {
        _categoryCount = counts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryCount = {};
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Color _getColorForCategory(String category, int index) {
    return _categoryColors[category.toLowerCase()] ?? _getDefaultColor(index);
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

    final entries = _categoryCount.entries.toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

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
                "Kegiatan per Kategori",
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
              if (!_isLoading)
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _loadStats,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat chart:\n$_error',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            )
          else if (entries.isEmpty || total == 0)
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
                  sections: entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final cat = entry.value.key;
                    final count = entry.value.value;

                    final color = _getColorForCategory(cat, index);
                    final pct = (count / total) * 100.0;

                    return PieChartSectionData(
                      value: count.toDouble(),
                      color: color,
                      title:
                          '${_getCategoryDisplayName(cat)}\n${pct.toStringAsFixed(1)}%',
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

          if (!_isLoading && _error == null && entries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: entries.asMap().entries.map((entry) {
                final index = entry.key;
                final cat = entry.value.key;
                final count = entry.value.value;
                final color = _getColorForCategory(cat, index);

                return _LegendDot(
                  color: color,
                  label: '${_getCategoryDisplayName(cat)} ($count)',
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
