// /lib/screens/DataWargaRumah/tabel_rumah_detail_page.dart

import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/house_model.dart';

class TabelRumahDetailPage extends StatelessWidget {
  final HouseModel house;

  const TabelRumahDetailPage({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rumah"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Sederhana
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 30, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        house.address ?? "Alamat Tidak Diketahui",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),

                // Detail Informasi Rumah
                InfoRow(
                  icon: Icons.home,
                  label: "Alamat Lengkap",
                  value: house.address ?? "-",
                ),
                InfoRow(
                  icon: Icons.square_foot,
                  label: "Area / Luas",
                  value: house.area?.toString() ?? "-", 
                ),
                InfoRow(
                  icon: Icons.info,
                  label: "Status dihuni",
                  value: house.status ?? "-",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}