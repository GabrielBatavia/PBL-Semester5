import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/family_model.dart';
import '../../services/family_service.dart';

class DetailKeluargaPage extends StatelessWidget {
  final FamilyModel family;

  const DetailKeluargaPage({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Keluarga"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CARD
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
                        Icons.family_restroom,
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
                            family.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Alamat: ${family.address ?? "-"}",
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

            // DETAIL INFORMASI CARD
            Card(
              elevation: 3,
              shadowColor: Colors.blue.withOpacity(0.3),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.people,
                      label: "Nama Keluarga",
                      value: family.name,
                    ),
                    InfoRow(
                      icon: Icons.numbers,
                      label: "Jumlah Anggota",
                      value: "${family.jumlahAnggota ?? 0}",
                    ),
                    InfoRow(
                      icon: Icons.home,
                      label: "Alamat",
                      value: family.address ?? "-",
                    ),
                    InfoRow(
                      icon: Icons.verified_user,
                      label: "Status",
                      value: family.status ?? "-",
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // JUDUL DAFTAR ANGGOTA
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                "Daftar Anggota Keluarga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            const Divider(),

            // DAFTAR ANGGOTA KELUARGA
            FutureBuilder<List<Map<String, dynamic>>>(
              future: FamilyService.instance.getFamilyMembers(family.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Gagal memuat anggota: ${snapshot.error}"));
                }
                
                final members = snapshot.data ?? [];
                
                if (members.isEmpty) {
                  return const Center(child: Text("Tidak ada anggota terdaftar."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(member['name'] ?? 'Nama Tidak Diketahui'),
                        subtitle: Text('NIK: ${member['nik'] ?? '-'}'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}