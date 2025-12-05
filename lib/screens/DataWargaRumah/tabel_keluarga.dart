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
  final TextEditingController _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  late Future<List<FamilyModel>> _futureFamilies;

  @override
  void initState() {
    super.initState();
    _futureFamilies = FamilyService.instance.fetchFamilies();
  }

  void _reload() {
    setState(() {
      _futureFamilies = FamilyService.instance.fetchFamilies(
        search: _controller.text.trim(),
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
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyFormPage()),
              );
              _reload();
            },
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 122, 142, 228)),
            label: const Text(
              "Tambah",
              style: TextStyle(color: Color.fromARGB(255, 122, 142, 228)),
            ),
          )
        ],
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari nama keluarga...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

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

                final families = snapshot.data ?? [];

                if (families.isEmpty) {
                  return const Center(child: Text("Tidak ada data keluarga"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: families.length,
                  itemBuilder: (context, i) {
                    final f = families[i];

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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),

                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Row(
                                children: const [
                                  Icon(Icons.family_restroom,
                                      size: 30,
                                      color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    "Detail Keluarga",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 12),

                              InfoRow(
                                icon: Icons.people,
                                label: "Nama Keluarga",
                                value: f.name,
                              ),

                              InfoRow(
                                icon: Icons.confirmation_number,
                                label: "Jumlah Anggota",
                                value: "${f.jumlahAnggota}",
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // ✔ EDIT (identik dengan TabelWarga)
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

                                  const SizedBox(width: 10),

                                  // ✔ DELETE (identik dengan TabelWarga)
                                  TextButton.icon(
                                    onPressed: () async {
                                      final ok = await FamilyService.instance
                                          .deleteFamily(f.id);

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            ok ? "Berhasil dihapus"
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
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
