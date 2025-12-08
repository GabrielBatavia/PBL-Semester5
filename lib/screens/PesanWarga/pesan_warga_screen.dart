import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/pesan/pesan_warga_form.dart';

class PesanWargaScreen extends StatefulWidget {
  const PesanWargaScreen({super.key});

  @override
  State<PesanWargaScreen> createState() => _PesanWargaScreenState();
}

class _PesanWargaScreenState extends State<PesanWargaScreen> {
  final List<Map<String, String>> pesanList = [
    {
      "nama": "Budi Santoso",
      "tgl": "12 Des 2025",
      "pesan": "Pak RW, saya ingin melaporkan adanya sampah menumpuk di dekat pos ronda."
    },
    {
      "nama": "Ibu Rina",
      "tgl": "11 Des 2025",
      "pesan": "Mohon jadwal posyandu bulan depan diinformasikan lebih awal, terima kasih."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Pesan Warga"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A11CB),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KirimPesanScreen()),
          );
        },
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
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pesan Warga",
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white, fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  "Kumpulan pesan & laporan dari warga kepada pengurus RW.",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ),

              const SizedBox(height: 10),

              // WHITE AREA
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: pesanList.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada pesan dari warga.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: pesanList.length,
                          itemBuilder: (context, i) {
                            final item = pesanList[i];
                            return _pesanCard(item);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pesanCard(Map<String, String> data) {
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
          Text(data["nama"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(data["tgl"]!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 10),
          Text(data["pesan"]!, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}