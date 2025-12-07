import 'package:flutter/material.dart';
import '../../models/house_model.dart';
import '../../services/house_service.dart';
import '../../utils/debouncer.dart';

import 'rumah_detail_page.dart';
import 'rumah_form_page.dart';

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
        _futureHouses = HouseService.instance.fetchHouses(
          search: _controller.text,
        );
      });
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _futureHouses = HouseService.instance.fetchHouses();
    });
  }

  Future<void> _deleteHouse(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Rumah"),
        content: const Text("Yakin ingin menghapus data rumah ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HouseService.instance.deleteHouse(id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // APPBAR BARU
      appBar: AppBar(
        automaticallyImplyLeading: false, // HILANGKAN TOMBOL BACK
        title: const Text("Data Rumah"),

        actions: [
          
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HouseFormPage(),
                ),
              );
              _refresh();
            },
            icon: const Icon(Icons.add, color: Colors.blue),
            label: const Text(
              "Tambah",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ----------------------
      // BODY
      // ----------------------
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
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

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TabelRumahDetailPage(house: h),
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
                                  Icon(
                                    Icons.home_work,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Detail Rumah",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 12),

                              _info(
                                icon: Icons.location_on,
                                label: "Alamat",
                                value: h.address,
                              ),
                              _info(
                                icon: Icons.map,
                                label: "Area",
                                value: h.area ?? "-",
                              ),
                              _info(
                                icon: Icons.info,
                                label: "Status",
                                value: h.status ?? "-",
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              HouseFormPage(existing: h),
                                        ),
                                      );
                                      _refresh();
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton.icon(
                                    onPressed: () => _deleteHouse(h.id),
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
          ),
        ],
      ),
    );
  }

  Widget _info({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text("$label : ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
