import 'package:flutter/material.dart';
import '../../models/citizen_request_model.dart';
import '../../services/citizen_request_service.dart';
import 'citizen_request_form_page.dart';
import 'citizen_request_detail_page.dart';
import '../../utils/debouncer.dart';

const Color _primaryDark = Color(0xFF5E35B1);

class CitizenRequestListPage extends StatefulWidget {
  final CitizenRequestModel? data;
  const CitizenRequestListPage({super.key, this.data});

  @override
  State<CitizenRequestListPage> createState() =>
      _CitizenRequestListPageState();
}

class _CitizenRequestListPageState extends State<CitizenRequestListPage> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  late Future<List<CitizenRequestModel>> _futureRequests;

  @override
  void initState() {
    super.initState();
    _futureRequests = CitizenRequestService().getAll();
  }

  void _reload() {
    setState(() {
      _futureRequests =
          CitizenRequestService().getAll(search: _controller.text);
    });
  }

  void _onSearchChanged() {
    _debouncer.run(() => _reload());
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 90, 36, 170),
            Color.fromARGB(255, 74, 18, 172),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Column(
              children: [
                Text(
                  "Permohonan Warga",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Kelola data permohonan warga",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CitizenRequestFormPage()),
                );
                _reload();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _buildRequestCard(CitizenRequestModel item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFF3E5F5),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CitizenRequestDetailPage(item.id!),
            ),
          );
          _reload();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  const Icon(Icons.assignment,
                      size: 30, color: _primaryDark),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "Status: ${item.status}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(item.status),
                ),
              ),

              const SizedBox(height: 12),

              // ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // DETAIL
                  TextButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CitizenRequestDetailPage(item.id!),
                        ),
                      );
                      _reload();
                    },
                    icon: const Icon(Icons.visibility,
                        color: _primaryDark),
                    label: const Text(
                      "Detail",
                      style: TextStyle(color: _primaryDark),
                    ),
                  ),

                  Row(
                    children: [
                      // EDIT
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CitizenRequestFormPage(data: item),
                            ),
                          );
                          _reload();
                        },
                        icon:
                            const Icon(Icons.edit, color: Colors.blue),
                        label: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // DELETE
                      TextButton.icon(
                        onPressed: () async {
                          await CitizenRequestService().delete(item.id!);
                          _reload();
                        },
                        icon: const Icon(Icons.delete_outline,
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
            ],
          ),
        ),
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Cari nama...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // LIST
          Expanded(
            child: FutureBuilder<List<CitizenRequestModel>>(
              future: _futureRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Gagal memuat data"));
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                      child: Text("Tidak ada data"));
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (_, i) =>
                      _buildRequestCard(data[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
