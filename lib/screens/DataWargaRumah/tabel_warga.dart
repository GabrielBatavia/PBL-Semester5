import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/resident_model.dart';
import '../../services/resident_service.dart';
import '../../utils/debouncer.dart';
import 'warga_detail_page.dart';

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

  void _onSearchChanged() {
    _debouncer.run(() {
      setState(() {
        _futureResidents = ResidentService.instance
            .fetchResidents(search: _controller.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 🔎 SEARCH BAR
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
                return const Center(
                  child: Text("Tidak ada data warga ditemukan"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: residents.length,
                itemBuilder: (context, i) {
                  final r = residents[i];

                  return InkWell(
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
                        child: Row(
                          children: [
                            // Info Kiri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                ],
                              ),
                            ),

                            // ICON PANAH
                            const Icon(
                              Icons.chevron_right,
                              size: 28,
                              color: Colors.grey,
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
        ),
      ],
    );
  }
}
