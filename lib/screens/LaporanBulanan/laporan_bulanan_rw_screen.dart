import 'package:flutter/material.dart';

class LaporanBulananRwScreen extends StatefulWidget {
  const LaporanBulananRwScreen({super.key});

  @override
  State<LaporanBulananRwScreen> createState() => _LaporanBulananRwScreenState();
}

class _LaporanBulananRwScreenState extends State<LaporanBulananRwScreen>
    with SingleTickerProviderStateMixin {
  String? selectedBulan;
  String? selectedTahun;

  final List<String> bulanList = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  final List<String> tahunList = ['2023', '2024', '2025', '2026', '2027'];

  late TabController _tabController;

  final List<Map<String, dynamic>> laporanMingguan = [
    {
      "minggu": "Minggu 1",
      "uraian": "Kerja bakti RT/RW",
      "tujuan": "Membersihkan lingkungan",
      "sasaran": "Seluruh warga"
    },
    {
      "minggu": "Minggu 2",
      "uraian": "Posyandu bulanan",
      "tujuan": "Pemeriksaan balita dan lansia",
      "sasaran": "Balita & lansia"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Laporan Bulanan RW"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A11CB),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ---------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Laporan Bulanan RW",
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white, fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  "Pilih bulan dan tahun untuk melihat laporan kegiatan & keuangan.",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // DROPDOWN FILTER -----------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // BULAN
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text("Bulan"),
                          value: selectedBulan,
                          items: bulanList
                              .map((b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedBulan = v),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // TAHUN
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text("Tahun"),
                          value: selectedTahun,
                          items: tahunList
                              .map((b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedTahun = v),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // WHITE CONTAINER -----------------------------------------
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      // TAB BAR -----------------------------------------
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.deepPurple,
                        tabs: const [
                          Tab(text: "Kegiatan"),
                          Tab(text: "Pemasukan"),
                          Tab(text: "Pengeluaran"),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // TAB CONTENT -------------------------------------
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLaporanKegiatan(),
                            _buildPlaceholder("Belum ada data pemasukan."),
                            _buildPlaceholder("Belum ada data pengeluaran."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ TAB KONTEN LAPORAN MINGGUAN ---------------------

  Widget _buildLaporanKegiatan() {
    if (selectedBulan == null || selectedTahun == null) {
      return const Center(
        child: Text(
          "Silakan pilih bulan & tahun terlebih dahulu.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: laporanMingguan.length,
      itemBuilder: (context, index) {
        final d = laporanMingguan[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d["minggu"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 8),
              _row("Uraian", d["uraian"].toString()),
              _row("Tujuan", d["tujuan"].toString()),
              _row("Sasaran", d["sasaran"].toString()),
            ],
          ),
        );
      },
    );
  }

  // ---------------------- KONTEN KOSONG ----------------------

  Widget _buildPlaceholder(String text) => Center(
        child: Text(text, style: const TextStyle(fontSize: 16)),
      );

  // ----------------------- ROW DETAIL ------------------------

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}