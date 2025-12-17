import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../models/citizen_request_model.dart';
import '../../services/citizen_request_service.dart';
import 'citizen_request_form_page.dart';

class CitizenRequestDetailPage extends StatefulWidget {
  final int id;

  const CitizenRequestDetailPage(this.id, {super.key});

  @override
  State<CitizenRequestDetailPage> createState() => _CitizenRequestDetailPageState();
}

class _CitizenRequestDetailPageState extends State<CitizenRequestDetailPage> {
  late Future<CitizenRequestModel?> _futureItem;

  @override
  void initState() {
    super.initState();
    _futureItem = loadData();
  }

  Future<CitizenRequestModel?> loadData() async {
    return await CitizenRequestService().getById(widget.id);
  }

  String _cleanString(String? text) {
    if (text == null) return "-";
    return text.replaceAll('\u00A0', ' ').trim();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmAndDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Permohonan"),
        content: const Text("Apakah Anda yakin ingin menghapus permohonan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await CitizenRequestService().delete(id);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permohonan berhasil dihapus")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus permohonan")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CitizenRequestModel?>(
      future: _futureItem,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final item = snapshot.data;
        if (snapshot.hasError || item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail Permohonan")),
            body: Center(child: Text("Gagal memuat data atau data tidak ditemukan.")),
          );
        }

        final request = item;
        final statusColor = _getStatusColor(request.status);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Detail Permohonan"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: statusColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: statusColor.withOpacity(0.1),
                          child: Icon(
                            Icons.description,
                            size: 38,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _cleanString(request.name),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Status: ${_cleanString(request.status)}",
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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

                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    "Detail Data Pemohon",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.credit_card,
                          label: "NIK",
                          value: _cleanString(request.nik),
                        ),
                        InfoRow(
                          icon: Icons.email,
                          label: "Email",
                          value: _cleanString(request.email),
                        ),
                        InfoRow(
                          icon: Icons.wc,
                          label: "Jenis Kelamin",
                          value: _cleanString(request.gender),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    "Foto Identitas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        request.identityImageUrl != null &&
                                request.identityImageUrl!.isNotEmpty
                            ? Center(
                                child: Image.network(
                                  request.identityImageUrl!,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text("Gagal memuat foto identitas.");
                                  },
                                ),
                              )
                            : const Text("Tidak ada foto identitas terlampir"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
