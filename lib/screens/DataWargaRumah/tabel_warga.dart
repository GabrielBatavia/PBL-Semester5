import 'package:flutter/material.dart';
import 'package:jawaramobile_1/screens/DataWargaRumah/warga_detail_page.dart';
import '../../widgets/info_row.dart';
import '../../models/resident_model.dart';
import '../../services/resident_service.dart';
import '../../utils/debouncer.dart';
import 'resident_form_page.dart';


class TabelWarga extends StatefulWidget {
  const TabelWarga({super.key});

  @override
  State<TabelWarga> createState() => _TabelWargaState();
}

class _TabelWargaState extends State<TabelWarga> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  late Future<List<ResidentModel>> _futureResidents;

  @override
  void initState() {
    super.initState();
    _futureResidents = ResidentService.instance.fetchResidents();
  }

  void _reload() {
    setState(() {
      _futureResidents =
          ResidentService.instance.fetchResidents(search: _controller.text);
    });
  }

  void _onSearchChanged() {
    _debouncer.run(() => _reload());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Warga"),

      

        actions: [
          
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FormResidentPage(),
                ),
              );
              _reload();
            },
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 122, 142, 228)),
            label: const Text(
              "Tambah",
              style: TextStyle(color: Color.fromARGB(255, 122, 142, 228)),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari nama / NIK...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<ResidentModel>>(
              future: _futureResidents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Gagal memuat data warga"));
                }

                final residents = snapshot.data ?? [];

                if (residents.isEmpty) {
                  return const Center(child: Text("Tidak ada data warga"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: residents.length,
                  itemBuilder: (context, i) {
                    final r = residents[i];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),


                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TabelWargaDetailPage(resident: r),
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
                                  Icon(Icons.home, size: 30, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    "Detail Warga",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 12),

                              InfoRow(
                                icon: Icons.person,
                                label: "Nama",
                                value: r.name,
                              ),

                              InfoRow(
                                icon: Icons.credit_card,
                                label: "NIK",
                                value: r.nik ?? "-",
                              ),

                              const SizedBox(height: 12),

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
                                              FormResidentPage(existingData: r),
                                        ),
                                      );
                                      _reload();
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // DELETE
                                  TextButton.icon(
                                    onPressed: () async {
                                      final ok = await ResidentService.instance
                                          .deleteResident(r.id);

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(ok
                                              ? "Berhasil dihapus"
                                              : "Gagal menghapus"),
                                        ),
                                      );
                                      _reload();
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
