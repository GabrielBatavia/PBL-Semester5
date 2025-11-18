// lib/screens/penerimaan_warga_screen.dart

import 'package:flutter/material.dart';
import '../theme/AppTheme.dart';
import 'package:go_router/go_router.dart';

// Model data untuk simulasi
class PermintaanAkun {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String fotoIdentitasUrl;

  PermintaanAkun({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasUrl,
  });
}

class PenerimaanWargaScreen extends StatefulWidget {
  const PenerimaanWargaScreen({super.key});

  @override
  State<PenerimaanWargaScreen> createState() => _PenerimaanWargaScreenState();
}

class _PenerimaanWargaScreenState extends State<PenerimaanWargaScreen> {
  // Data simulasi
  final List<PermintaanAkun> _permintaanList = [
    PermintaanAkun(
      no: 1,
      nama: 'Rendha Putra Rahmadya',
      nik: '3505111512040002',
      email: 'rendhazupez@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasUrl:
          'https://placehold.co/100x70/7F00FF/D8BFD8?text=Foto+Identitas+1',
    ),
    PermintaanAkun(
      no: 2,
      nama: 'Anti Micin',
      nik: '1234567890987654',
      email: 'antimicin3@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasUrl:
          'https://placehold.co/100x70/4C008D/D8BFD8?text=Foto+Identitas+2',
    ),
    PermintaanAkun(
      no: 3,
      nama: 'Ijat',
      nik: '2025202520252025',
      email: 'ijat1@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasUrl:
          'https://placehold.co/100x70/7F00FF/D8BFD8?text=Foto+Identitas+3',
    ),
  ];

  String? _filterNama;
  String? _filterJenisKelamin;
  String? _filterStatus;

  // =========================================================================
  // MODAL FILTER
  // =========================================================================
  void _showFilterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? currentNama = _filterNama;
        String? currentJenisKelamin = _filterJenisKelamin;
        String? currentStatus = _filterStatus;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.all(24),
              contentPadding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Penerimaan Warga',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Filter
                  Text(
                    'Nama',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: currentNama,
                    decoration: InputDecoration(
                      hintText: 'Cari nama...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      currentNama = value.isEmpty ? null : value;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Jenis Kelamin Filter
                  Text(
                    'Jenis Kelamin',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: currentJenisKelamin,
                    hint: const Text('-- Pilih Jenis Kelamin --'),
                    items: ['L', 'P'].map((String jk) {
                      return DropdownMenuItem<String>(
                        value: jk,
                        child: Text(jk == 'L' ? 'Laki-laki' : 'Perempuan'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setStateModal(() {
                        currentJenisKelamin = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Filter
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: currentStatus,
                    hint: const Text('-- Pilih Status --'),
                    items: ['Pending', 'Diterima', 'Ditolak'].map((status) {
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Reset filter
                          setState(() {
                            _filterNama = null;
                            _filterJenisKelamin = null;
                            _filterStatus = null;
                          });
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryOrange,
                          side: BorderSide(color: AppTheme.primaryOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reset Filter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Terapkan filter
                          setState(() {
                            _filterNama = currentNama;
                            _filterJenisKelamin = currentJenisKelamin;
                            _filterStatus = currentStatus;
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.highlightYellow,
                          foregroundColor: AppTheme.darkBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Terapkan'),
                      ),
                    ],
                  ),
                ],
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
  List<PermintaanAkun> get _filteredPermintaanList {
    if (_filterNama == null &&
        _filterJenisKelamin == null &&
        _filterStatus == null) {
      return _permintaanList;
    }

    return _permintaanList.where((permintaan) {
      final matchesNama = _filterNama == null ||
          permintaan.nama.toLowerCase().contains(_filterNama!.toLowerCase());
      final matchesJK = _filterJenisKelamin == null ||
          permintaan.jenisKelamin.toLowerCase() ==
              _filterJenisKelamin!.toLowerCase();
      // Status belum digunakan di data dummy
      return matchesNama && matchesJK;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredList = _filteredPermintaanList;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              pinned: true,
              centerTitle: true,
              title: Text(
                'Penerimaan Warga',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.goNamed('aspirasi');
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _showFilterModal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.highlightYellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            elevation: 5,
                            minimumSize: const Size(60, 50),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

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
                          columns: const [
                            DataColumn(label: Text('NO')),
                            DataColumn(label: Text('NAMA')),
                            DataColumn(label: Text('NIK')),
                            DataColumn(label: Text('EMAIL')),
                            DataColumn(label: Text('JENIS KELAMIN')),
                            DataColumn(label: Text('FOTO IDENTITAS')),
                          ],
                          rows: filteredList.map((permintaan) {
                            return DataRow(
                              cells: [
                                DataCell(Text(permintaan.no.toString())),
                                DataCell(Text(permintaan.nama)),
                                DataCell(Text(permintaan.nik)),
                                DataCell(Text(permintaan.email)),
                                DataCell(Text(permintaan.jenisKelamin)),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Nanti bisa ditambah preview full-screen
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        permintaan.fotoIdentitasUrl,
                                        width: 70,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 70,
                                            height: 50,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 20,
                                                color: AppTheme.primaryOrange,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Pagination (dummy)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: AppTheme.darkBrown,
                            ),
                            onPressed: () {},
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.highlightYellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: AppTheme.darkBrown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.darkBrown,
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
    );
  }
}
