// lib/screens/Kegiatan/daftar_kegiatan.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/services/kegiatan_service.dart';
import 'package:jawaramobile_1/widgets/kegiatan/kegiatan_filter.dart';
import 'package:jawaramobile_1/utils/session.dart' as session;

class KegiatanScreen extends StatefulWidget {
  const KegiatanScreen({super.key});

  @override
  State<KegiatanScreen> createState() => _KegiatanScreenState();
}

class _KegiatanScreenState extends State<KegiatanScreen> {
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> _kegiatanList = [];

  @override
  void initState() {
    super.initState();
    _loadKegiatan();
  }

  Future<void> _loadKegiatan() async {
    try {
      final int userId = await session.Session.getUserId();
      final String role = await session.Session.getUserRole();

      final raw = await KegiatanService.instance.getKegiatanByRoleImpl(
        userId: userId,
        role: role,
      );

      _kegiatanList = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      _streamController.add(_kegiatanList);
    } catch (e) {
      // penting: test kamu expect text error muncul di widget tree
      _streamController.addError(e);
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter Kegiatan"),
        content: const SingleChildScrollView(child: KegiatanFilter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cari"),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return "-";
    try {
      final s = raw.toString();
      final dt = DateTime.parse(s.length >= 10 ? s.substring(0, 10) : s);
      // jangan pakai locale spesifik biar stabil di test environment
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return raw.toString();
    }
  }

  String _take(dynamic v) => (v == null || v.toString().trim().isEmpty)
      ? "-"
      : v.toString().trim();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Kegiatan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKegiatan,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah-kegiatan'),
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Kegiatan',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamController.stream,
                      initialData: const <Map<String, dynamic>>[],
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // biar match dengan test yang cari "Error: ..."
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final data = snapshot.data ?? const [];
                        if (data.isEmpty) {
                          return const Center(child: Text("Tidak ada kegiatan"));
                        }

                        return RefreshIndicator(
                          onRefresh: _loadKegiatan,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: data.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = data[index];

                              final name = _take(item['name']);
                              final date = _formatDate(item['date']);
                              final location = _take(item['location']);
                              final pic = _take(item['pic_name']);
                              final category = _take(item['category']);
                              final desc = _take(item['description']);

                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => context.push(
                                  '/detail-kegiatan',
                                  extra: item,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.06),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 14,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: colorScheme.primary
                                              .withOpacity(0.10),
                                        ),
                                        child: Icon(
                                          Icons.event_note,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    date,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    location,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (desc != "-" &&
                                                desc.trim().isNotEmpty) ...[
                                              const SizedBox(height: 10),
                                              Text(
                                                desc,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 10),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                _ChipMini(
                                                  icon: Icons.category,
                                                  label: category == "-"
                                                      ? "Tanpa kategori"
                                                      : category,
                                                  bg: Colors.blue
                                                      .withOpacity(0.08),
                                                  fg: Colors.blue[800]!,
                                                ),
                                                if (pic != "-" &&
                                                    pic.trim().isNotEmpty)
                                                  _ChipMini(
                                                    icon: Icons.person,
                                                    label: pic,
                                                    bg: Colors.orange
                                                        .withOpacity(0.10),
                                                    fg: Colors.orange[800]!,
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.chevron_right,
                                          color: Colors.grey[500]),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  const _ChipMini({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 190),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
