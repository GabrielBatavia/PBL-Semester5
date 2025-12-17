import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/mutations_model.dart';

class MutasiDetailPage extends StatelessWidget {
  final MutasiModel data;

  const MutasiDetailPage({super.key, required this.data});

  String _capitalize(String text) {
    if (text.isEmpty) return "-";
    final lower = text.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mutasi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CARD (Seperti Detail Keluarga)
            Card(
              elevation: 4,
              shadowColor: Colors.blue.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.swap_horiz,
                        size: 38,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _capitalize(data.mutationType),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Keluarga: ${data.familyName}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DETAIL CARD
            Card(
              elevation: 3,
              shadowColor: Colors.blue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.family_restroom,
                      label: "Nama Keluarga",
                      value: data.familyName ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.badge,
                      label: "Family ID",
                      value: "${data.familyId}",
                    ),
                    InfoRow(
                      icon: Icons.sync_alt,
                      label: "Jenis Mutasi",
                      value: _capitalize(data.mutationType),
                    ),
                    InfoRow(
                      icon: Icons.calendar_today,
                      label: "Tanggal",
                      value: data.date,
                    ),
                    if (data.mutationType != "masuk")
                      InfoRow(
                        icon: Icons.location_off,
                        label: "Alamat Lama",
                        value: data.oldAddress ?? "-",
                      ),
                    if (data.mutationType != "keluar")
                      InfoRow(
                        icon: Icons.location_on,
                        label: "Alamat Baru",
                        value: data.newAddress ?? "-",
                      ),
                    InfoRow(
                      icon: Icons.info_outline,
                      label: "Alasan",
                      value: data.reason ?? "-",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
