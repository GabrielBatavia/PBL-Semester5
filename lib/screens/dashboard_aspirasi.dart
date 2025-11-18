// lib/screens/dashboard_aspirasi.dart
import 'package:flutter/material.dart';
import '../theme/AppTheme.dart';
import '../widgets/status_chip.dart';
import 'edit_pesan_screen.dart';

// Model data untuk simulasi
class PesanWarga {
  final int no;
  final String pengirim;
  final String judul;
  final String status;
  final String tanggalDibuat;

  PesanWarga({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.status,
    required this.tanggalDibuat,
  });
}

class DashboardAspirasi extends StatefulWidget {
  const DashboardAspirasi({super.key});

  @override
  State<DashboardAspirasi> createState() => _DashboardAspirasiState();
}

class _DashboardAspirasiState extends State<DashboardAspirasi> {
  // Data simulasi
  final List<PesanWarga> _pesanList = [
    PesanWarga(
      no: 1,
      pengirim: 'Varizky Naldiba Rimra',
      judul: 'titootit',
      status: 'Diterima',
      tanggalDibuat: '16 Oktober 2025',
    ),
    PesanWarga(
      no: 2,
      pengirim: 'Habibie Ed Dien',
      judul: 'tes',
      status: 'Pending',
      tanggalDibuat: '28 September 2025',
    ),
    PesanWarga(
      no: 3,
      pengirim: 'Ahmad Fulan',
      judul: 'Aspirasi RT 05',
      status: 'Pending',
      tanggalDibuat: '01 Oktober 2025',
    ),
    PesanWarga(
      no: 4,
      pengirim: 'Siti Aminah',
      judul: 'Usul Perbaikan Jalan',
      status: 'Diterima',
      tanggalDibuat: '10 September 2025',
    ),
  ];

  String? _filterJudul;
  String? _filterStatus;

  int get _totalPending =>
      _pesanList.where((e) => e.status.toLowerCase() == 'pending').length;
  int get _totalDiterima =>
      _pesanList.where((e) => e.status.toLowerCase() == 'diterima').length;

  // =========================================================================
  // MODAL FILTER
  // =========================================================================
  void _showFilterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? currentJudul = _filterJudul;
        String? currentStatus = _filterStatus;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            final theme = Theme.of(context);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Pesan Warga',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Judul',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: currentJudul,
                      decoration: const InputDecoration(
                        hintText: 'Cari judul...',
                      ),
                      onChanged: (value) {
                        currentJudul = value.isEmpty ? null : value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Status',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: currentStatus,
                      hint: const Text('-- Pilih Status --'),
                      items: ['Diterima', 'Pending', 'Ditolak']
                          .map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateModal(() {
                          currentStatus = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterJudul = null;
                              _filterStatus = null;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filterJudul = currentJudul;
                              _filterStatus = currentStatus;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Terapkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // FUNGSI UTAMA
  // =========================================================================
  List<PesanWarga> get _filteredPesanList {
    if (_filterJudul == null && _filterStatus == null) {
      return _pesanList;
    }

    return _pesanList.where((pesan) {
      final matchesJudul =
          _filterJudul == null ||
              pesan.judul.toLowerCase().contains(_filterJudul!.toLowerCase());
      final matchesStatus =
          _filterStatus == null ||
              pesan.status.toLowerCase() == _filterStatus!.toLowerCase();
      return matchesJudul && matchesStatus;
    }).toList();
  }

  Widget _buildStatPill(
    BuildContext context, {
    required String label,
    required String value,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: (color ?? AppTheme.highlightYellow).withOpacity(0.14),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredList = _filteredPesanList;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pesan Warga'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryOrange,
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard Aspirasi',
                        style: theme.textTheme.displayLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola pesan dan aspirasi warga dengan mudah.',
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 18),

                      // Little summary pills
                      Row(
                        children: [
                          _buildStatPill(
                            context,
                            label: 'Total Pesan',
                            value: _pesanList.length.toString(),
                          ),
                          _buildStatPill(
                            context,
                            label: 'Pending',
                            value: _totalPending.toString(),
                            color: const Color(0xFFFFC857),
                          ),
                          _buildStatPill(
                            context,
                            label: 'Diterima',
                            value: _totalDiterima.toString(),
                            color: const Color(0xFF22C55E),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _showFilterModal(context),
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.highlightYellow.withOpacity(0.18),
                              foregroundColor: AppTheme.darkBrown,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Data Table (Scrollable)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 24,
                            horizontalMargin: 8,
                            headingRowColor: MaterialStateProperty.all(
                              AppTheme.warmCream,
                            ),
                            headingTextStyle:
                                theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                            ),
                            dataTextStyle:
                                theme.textTheme.bodyMedium!.copyWith(
                              color: AppTheme.darkBrown,
                            ),
                            columns: const [
                              DataColumn(label: Text('NO')),
                              DataColumn(label: Text('PENGIRIM')),
                              DataColumn(label: Text('JUDUL')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('TANGGAL')),
                              DataColumn(label: Text('AKSI')),
                            ],
                            rows: filteredList.map((pesan) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(pesan.no.toString())),
                                  DataCell(Text(pesan.pengirim)),
                                  DataCell(Text(pesan.judul)),
                                  DataCell(StatusChip(status: pesan.status)),
                                  DataCell(Text(pesan.tanggalDibuat)),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        color: AppTheme.primaryOrange,
                                      ),
                                      onSelected: (String result) {
                                        if (result == 'Edit') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditPesanScreen(),
                                            ),
                                          );
                                        } else if (result == 'Detail') {
                                          // TODO: Implement Detail Screen
                                        } else if (result == 'Hapus') {
                                          // TODO: Implement Delete Confirmation
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          const <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'Detail',
                                          child: Text('Detail'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Hapus',
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Pagination (Dummy)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: Colors.black45,
                              ),
                              onPressed: () {},
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black45,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
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
