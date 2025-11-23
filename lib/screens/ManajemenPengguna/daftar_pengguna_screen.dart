// lib/screens/ManajemenPengguna/daftar_pengguna_screen.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/models/user.dart';
import 'package:jawaramobile_1/services/user_service.dart';
import 'package:jawaramobile_1/widgets/manajemen_pengguna_filter.dart';

class DaftarPenggunaScreen extends StatefulWidget {
  const DaftarPenggunaScreen({super.key});

  @override
  State<DaftarPenggunaScreen> createState() => _DaftarPenggunaScreenState();
}

class _DaftarPenggunaScreenState extends State<DaftarPenggunaScreen> {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  String? _queryNama;
  String? _queryStatus; // "Diterima" / "Pending" / "Ditolak"

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await UserService.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat pengguna: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // mapping status backend -> label UI
  String _statusLabel(String? status) {
    final s = (status ?? '').toLowerCase();
    switch (s) {
      case 'diterima':
      case 'accepted':
      case 'active':
        return 'Diterima';
      case 'pending':
        return 'Pending';
      case 'ditolak':
      case 'rejected':
        return 'Ditolak';
      default:
        return status ?? '-';
    }
  }

  Color statusBg(String label) {
    switch (label) {
      case 'Diterima':
        return Colors.green.withOpacity(.12);
      case 'Pending':
        return Colors.orange.withOpacity(.12);
      case 'Ditolak':
        return Colors.red.withOpacity(.12);
      default:
        return Colors.grey.withOpacity(.12);
    }
  }

  Color statusFg(String label) {
    switch (label) {
      case 'Diterima':
        return Colors.green.shade800;
      case 'Pending':
        return Colors.orange.shade800;
      case 'Ditolak':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  List<User> get _filtered {
    return _users.where((u) {
      final label = _statusLabel(u.status);
      final okNama = _queryNama == null || _queryNama!.isEmpty
          ? true
          : u.name.toLowerCase().contains(_queryNama!.toLowerCase());
      final okStatus =
          _queryStatus == null || _queryStatus!.isEmpty ? true : label == _queryStatus;
      return okNama && okStatus;
    }).toList();
  }

  void _openFilter() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter Manajemen Pengguna"),
        content: const ManajemenPenggunaFilter(),
        actions: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                _queryNama = null;
                _queryStatus = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text("Reset Filter"),
          ),
          ElevatedButton(
            onPressed: () {
              // TEMP: di laporan kamu bisa jelaskan kalau filter formnya nanti di-wire ke _queryNama/_queryStatus
              Navigator.of(context).pop();
            },
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
    final rows = _filtered;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daftar Pengguna"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilter,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tambah-pengguna'),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.person_add_alt_1),
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
                  'Manajemen Pengguna',
                  style:
                      theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola akun admin, community head, dan warga.',
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
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? Center(
                                  child: Text(
                                    _error!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : rows.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Belum ada pengguna.',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    )
                                  : DataTable2(
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
                                        DataColumn2(label: Text('Nama')),
                                        DataColumn2(
                                          label: Text('Status'),
                                          size: ColumnSize.S,
                                        ),
                                      ],
                                      rows: rows.map((u) {
                                        final label = _statusLabel(u.status);
                                        return DataRow2(
                                          onTap: () {
                                            // TODO: route detail pengguna kalau nanti ada
                                            // context.push('/detail-pengguna', extra: u);
                                          },
                                          cells: [
                                            DataCell(
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    u.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    u.email,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme
                                                          .colorScheme.onSurface
                                                          .withOpacity(.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusBg(label),
                                                  borderRadius:
                                                      BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                  label,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: statusFg(label),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
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
