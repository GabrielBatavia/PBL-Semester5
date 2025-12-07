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
      body: Stack(
        children: [
          // =============================
          // HEADER GRADIENT
          // =============================
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF512DA8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // TITLE
                const Text(
                  "Data Keluarga",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                const Text(
                  "Kelola data keluarga dengan mudah.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),

                    child: Column(
                      children: [
                        // SEARCH BAR
                        TextField(
                          controller: searchCtrl,
                          onChanged: (_) => _onSearchChanged(),
                          decoration: InputDecoration(
                            hintText: "Cari nama keluarga...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // HEADER LIST + ADD BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Data Keluarga",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const FamilyFormPage()),
                                );
                                _reload();
                              },
                              icon: const Icon(Icons.add, color: Colors.blue),
                              label: const Text(
                                "Tambah",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // LIST DATA
                        Expanded(
                          child: FutureBuilder<List<FamilyModel>>(
                            future: _futureFamilies,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Gagal memuat data"));
                              }

                              final data = snapshot.data ?? [];

                              if (data.isEmpty) {
                                return const Center(
                                  child: Text("Tidak ada data keluarga"),
                                );
                              }

                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (_, i) {
                                  final f = data[i];

                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),

                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                DetailKeluargaPage(family: f),
                                          ),
                                        );
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.all(16),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(Icons.family_restroom,
                                                    size: 30,
                                                    color: Colors.blue),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Detail Keluarga",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 12),

                                            InfoRow(
                                              icon: Icons.people,
                                              label: "Nama Keluarga",
                                              value: f.name,
                                            ),

                                            InfoRow(
                                              icon: Icons.format_list_numbered,
                                              label: "Jumlah Anggota",
                                              value: "${f.jumlahAnggota}",
                                            ),

                                            const SizedBox(height: 12),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            FamilyFormPage(
                                                                existing: f),
                                                      ),
                                                    );
                                                    _reload();
                                                  },
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  label: const Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),

                                                TextButton.icon(
                                                  onPressed: () async {
                                                    final ok =
                                                        await FamilyService
                                                            .instance
                                                            .deleteFamily(
                                                                f.id);

                                                    if (!mounted) return;

                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                    style: TextStyle(
                                                        color: Colors.red),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
