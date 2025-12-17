import 'package:flutter/material.dart';
import '../../services/family_service.dart';
import '../../models/family_model.dart';
import '../../utils/debouncer.dart';
import 'keluarga_form_page.dart';
import 'keluarga_detail_page.dart';
import '../../widgets/info_row.dart';

class TabelKeluarga extends StatefulWidget {
  const TabelKeluarga({super.key});

  @override
  State<TabelKeluarga> createState() => _TabelKeluargaState();
}

class _TabelKeluargaState extends State<TabelKeluarga> {
  final TextEditingController searchCtrl = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 400);

  late Future<List<FamilyModel>> _futureFamilies;

  @override
  void initState() {
    super.initState();
    _futureFamilies = FamilyService.instance.fetchFamilies();
  }

  void _reload() {
    setState(() {
      _futureFamilies = FamilyService.instance.fetchFamilies(
        search: searchCtrl.text.trim(),
      );
    });
  }

  void _onSearchChanged() {
    _debouncer.run(() => _reload());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Data Keluarga"),
        actions: [
          // TOMBOL TAMBAH (ADD BUTTON)
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FamilyFormPage(),
                ),
              );
              _reload();
            },
            icon: const Icon(
              Icons.add,
              // Menggunakan warna yang sama dengan TabelWarga
              color: Color.fromARGB(255, 122, 142, 228),
            ),
            label: const Text(
              "Tambah",
              style: TextStyle(
                // Menggunakan warna dan fontWeight yang sama dengan TabelWarga
                color: Color.fromARGB(255, 122, 142, 228),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            // Menggunakan padding yang sama dengan TabelWarga
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari nama keluarga...", // Disesuaikan
                // Border style disamakan dengan TabelWarga
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // Menghapus filled: true dan fillColor
              ),
            ),
          ),

          // LIST DATA
          Expanded(
            child: FutureBuilder<List<FamilyModel>>(
              future: _futureFamilies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Gagal memuat data"));
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada data keluarga"),
                  );
                }

                return ListView.builder(
                  // Menggunakan padding yang sama dengan TabelWarga
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final f = data[i];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailKeluargaPage(family: f),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // Menggunakan margin yang sama dengan TabelWarga
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.family_restroom,
                                      size: 30, color: Colors.blue), // Disesuaikan
                                  SizedBox(width: 10),
                                  Text(
                                    "Detail Keluarga", // Disesuaikan
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              InfoRow(
                                icon: Icons.people, // Disesuaikan
                                label: "Nama Keluarga", // Disesuaikan
                                value: f.name,
                              ),

                              InfoRow(
                                icon: Icons.format_list_numbered,
                                label: "Jumlah Anggota",
                                value: "${f.jumlahAnggota}",
                              ),

                              const SizedBox(height: 12),

                              // TOMBOL EDIT & HAPUS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // EDIT
                                  TextButton.icon(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FamilyFormPage(existing: f),
                                        ),
                                      );
                                      _reload();
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),

                                  const SizedBox(width: 10), // Jarak disamakan

                                  // DELETE
                                  TextButton.icon(
                                    onPressed: () async {
                                      final ok = await FamilyService.instance
                                          .deleteFamily(f.id);

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            ok
                                                ? "Berhasil dihapus"
                                                : "Gagal menghapus",
                                          ),
                                        ),
                                      );

                                      _reload();
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
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
