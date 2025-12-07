import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/resident_model.dart';

class TabelWargaDetailPage extends StatelessWidget {
  final ResidentModel resident;

  const TabelWargaDetailPage({
    super.key,
    required this.resident,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Warga"),
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
                // HEADER — Nama Warga
                Row(
                  children: [
                    const Icon(Icons.person, size: 32, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        resident.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),

                /// DETAIL INFORMASI
                InfoRow(
                  icon: Icons.credit_card,
                  label: "NIK",
                  value: resident.nik ?? "-",
                ),
                InfoRow(
                  icon: Icons.family_restroom,
                  label: "ID Keluarga",
                  value: resident.familyId?.toString() ?? "-",
                ),
                InfoRow(
                  icon: Icons.cake,
                  label: "Tanggal Lahir",
                  value: resident.birthDate ?? "-",
                ),
                InfoRow(
                  icon: Icons.work,
                  label: "Pekerjaan",
                  value: resident.job ?? "-",
                ),
                InfoRow(
                  icon: Icons.male,
                  label: "Jenis Kelamin",
                  value: resident.gender ?? "-",
                ),
                InfoRow(
                  icon: Icons.person_pin_circle,
                  label: "User ID",
                  value: resident.userId?.toString() ?? "-",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
