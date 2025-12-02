import 'package:flutter/material.dart';
import '../../models/house_model.dart';
import '../../services/house_service.dart';
import '../../utils/debouncer.dart';

import 'rumah_detail_page.dart'; 

class TabelRumah extends StatefulWidget {
  const TabelRumah({super.key});

  @override
  State<TabelRumah> createState() => _TabelRumahState();
}

class _TabelRumahState extends State<TabelRumah> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  late Future<List<HouseModel>> _futureHouses;

  @override
  void initState() {
    super.initState();
    _futureHouses = HouseService.instance.fetchHouses();
    _controller.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      setState(() {
        _futureHouses = HouseService.instance
            .fetchHouses(search: _controller.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari alamat / status / area...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // 📄 LIST DATA
        Expanded(
          child: FutureBuilder<List<HouseModel>>(
            future: _futureHouses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Gagal memuat data rumah"));
              }

              final houses = snapshot.data ?? [];

              if (houses.isEmpty) {
                return const Center(child: Text("Tidak ada hasil"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  final h = houses[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      // Tampilan Minimal: Hanya Alamat
                      leading: const Icon(Icons.home_work),
                      title: Text(
                        h.address ?? "Alamat Tidak Diketahui",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // Subtitle bisa menunjukkan ID Keluarga
                      subtitle: Text("Status: ${h.status ?? '-'}"), 
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      
                      // Fungsi Navigasi
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TabelRumahDetailPage(house: h),
                          ),
                        );
                      },
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
