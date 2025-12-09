import 'package:flutter/material.dart';
import '../../models/citizen_request_model.dart';
import '../../services/citizen_request_service.dart';
import 'citizen_request_form_page.dart';
import 'citizen_request_detail_page.dart';
import '../../utils/debouncer.dart';

class CitizenRequestListPage extends StatefulWidget {
  final CitizenRequestModel? data;
  const CitizenRequestListPage({super.key, this.data});

  @override
  State<CitizenRequestListPage> createState() => _CitizenRequestListPageState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Permohonan Warga"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CitizenRequestFormPage()),
              );
              _reload();
            },
            icon: const Icon(Icons.add, color: Colors.blue),
            label: const Text("Tambah",
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.w600)),
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari nama...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<CitizenRequestModel>>(
              future: _futureRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final list = snapshot.data ?? [];

                if (list.isEmpty) {
                  return const Center(child: Text("Tidak ada data"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final item = list[i];

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CitizenRequestDetailPage(item.id!),
                            ),
                          );
                          _reload();
                        },

                        title: Text(item.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),

                        subtitle: Text("Status: ${item.status}",
                            style: TextStyle(
                                color: _getStatusColor(item.status))),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // EDIT BUTTON
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
                            ),

                            // DELETE BUTTON
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await CitizenRequestService()
                                    .delete(item.id!);
                                _reload();
                              },
                            ),
                          ],
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
}
