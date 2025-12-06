import 'package:flutter/material.dart';
import '../../services/mutation_service.dart';
import '../../models/mutations_model.dart';
import '../../utils/debouncer.dart';
import '../../widgets/info_row.dart'; 
import 'mutasi_detail_page.dart';
import 'mutasi_form_page.dart';

const Color _primaryDark = Color(0xFF5E35B1); 
const Color _secondaryLight = Color(0xFF5E35B1);

class TabelMutasi extends StatefulWidget {
  const TabelMutasi({super.key});

  @override
  State<TabelMutasi> createState() => _TabelMutasiState();
}

class _TabelMutasiState extends State<TabelMutasi> {
  final TextEditingController searchCtrl = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 400);

  late Future<List<MutasiModel>> _futureMutasi;

  @override
  void initState() {
    super.initState();
    _futureMutasi = MutasiService.instance.fetchMutations();
  }

  void _reload() {
    setState(() {
      _futureMutasi =
          MutasiService.instance.fetchMutations(search: searchCtrl.text);
    });
  }

  void _onSearchChanged() {
    _debouncer.run(() => _reload());
  }

  // --- Widget Bantuan untuk Header/Appbar ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      // Container dengan Gradasi Warna (Ungu/Biru)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 90, 36, 170), Color.fromARGB(255, 74, 18, 172)], // Contoh gradasi ungu
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row untuk Back Button dan Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
              const SizedBox(width: 48), 
            ],
          ),

          const SizedBox(height: 20),

         
          const Text(
            "Data Mutasi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            "Kelola data mutasi keluarga.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),

          
          const SizedBox(height: 20),

          // Tombol Tambah
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MutasiFormPage()),
                );
                _reload();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMutasiCard(MutasiModel m) {
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFF3E5F5), 
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MutasiDetailPage(data: m),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  const Icon(Icons.transform, size: 30, color: _primaryDark), // Ikon ungu gelap
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m.familyName ?? "Keluarga #${m.familyId}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.sync_alt,
                label: "Jenis Mutasi",
                value: m.mutationType.toUpperCase(),
              ),
              InfoRow(
                icon: Icons.place,
                label: "Alamat Baru",
                value: m.newAddress ?? "-",
              ),

              const SizedBox(height: 10),

              // ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tombol Edit
                  TextButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MutasiFormPage(existing: m),
                        ),
                      );
                      _reload();
                    },
                    icon: const Icon(Icons.edit, color: _secondaryLight),
                    label: const Text(
                      "Edit",
                      style: TextStyle(color: _secondaryLight),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Tombol Hapus
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Hapus Mutasi"),
                          content: const Text("Yakin ingin menghapus data ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await MutasiService.instance.delete(m.id);
                                _reload();
                              },
                              child: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      "Hapus",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Utama Build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Gradasi Warna
          _buildHeader(context),

          // 2. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Cari nama keluarga / mutasi...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100], 
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 3. List Data
          Expanded(
            child: FutureBuilder<List<MutasiModel>>(
              future: _futureMutasi,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text("Gagal memuat data mutasi")),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada data mutasi"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    return _buildMutasiCard(data[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}