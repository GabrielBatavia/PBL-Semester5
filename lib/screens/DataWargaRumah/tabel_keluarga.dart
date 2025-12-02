import 'package:flutter/material.dart';
import '../../models/family_model.dart';
import '../../services/family_service.dart';
import '../../utils/debouncer.dart';
import 'keluarga_detail_page.dart';

class TabelKeluarga extends StatefulWidget {
  const TabelKeluarga({super.key});

  @override
  State<TabelKeluarga> createState() => _TabelKeluargaState();
}

class _TabelKeluargaState extends State<TabelKeluarga> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  late Future<List<FamilyModel>> _futureFamilies;

  @override
  void initState() {
    super.initState();
    _futureFamilies = FamilyService.instance.fetchFamilies();
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      setState(() {
        _futureFamilies = FamilyService.instance
            .fetchFamilies(search: _controller.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SEARCH FIELD
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            onChanged: (_) => _onSearchChanged(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari nama keluarga / NIK...",
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
                return const Center(child: Text("Gagal memuat data keluarga"));
              }

              final families = snapshot.data ?? [];

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: families.length,
                itemBuilder: (context, i) {
                  final f = families[i];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 14),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.family_restroom, color: Colors.blue.shade700),
                      ),

                      title: Text(
                        f.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        "status: ${f.status ?? "-"}",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),

                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailKeluargaPage(family: f),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
