// lib/screens/LogActivity/log_activity_screen.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/models/log_entry.dart';
import 'package:jawaramobile_1/services/log_service.dart';
import 'package:jawaramobile_1/widgets/log_aktivitas_filter.dart';

class LogActivityScreen extends StatefulWidget {
  const LogActivityScreen({super.key});

  @override
  State<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends State<LogActivityScreen> {
  late final Stream<List<LogEntry>> _logStream;

  @override
  void initState() {
    super.initState();
    _logStream = LogService.logsStream(); // polling tiap 5 detik
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter Log Aktivitas"),
        content: const LogAktivitasFilter(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Terapkan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Log Aktivitas"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // opsional: tambah log manual
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
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
                  'Log Aktivitas Sistem',
                  style:
                      theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Riwayat lengkap perubahan data oleh admin & pengurus.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: StreamBuilder<List<LogEntry>>(
                        stream: _logStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Gagal memuat log: ${snapshot.error}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          final logs = snapshot.data ?? [];

                          if (logs.isEmpty) {
                            return Center(
                              child: Text(
                                'Belum ada aktivitas.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            );
                          }

                          return DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            headingRowColor: MaterialStateProperty.all(
                              colorScheme.primary.withOpacity(0.05),
                            ),
                            headingTextStyle:
                                theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            columns: const [
                              DataColumn2(label: Text('Deskripsi')),
                              DataColumn2(
                                label: Text('Tanggal'),
                                size: ColumnSize.S,
                              ),
                            ],
                            rows: logs.map((log) {
                              return DataRow2(
                                onTap: () => context.push(
                                  '/detail-log-aktivitas',
                                  extra: {
                                    'no': log.id.toString(),
                                    'deskripsi': log.description,
                                    'aktor': log.actorName,
                                    'tanggal': log.formattedDate,
                                  },
                                ),
                                cells: [
                                  DataCell(
                                    Text(
                                      log.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DataCell(Text(log.formattedDate)),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
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
