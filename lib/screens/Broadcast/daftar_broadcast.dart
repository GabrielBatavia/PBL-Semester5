import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/broadcast_service.dart';
import 'package:jawaramobile_1/widgets/broadcast/broadcast_filter.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController.broadcast();

  List<Map<String, dynamic>> _broadcastList = [];

  @override
  void initState() {
    super.initState();
    _loadBroadcast();
  }

  Future<void> _loadBroadcast() async {
    final List<dynamic> data = await BroadcastService.getBroadcastList();

    // pastikan semua item adalah Map<String, dynamic>
    _broadcastList = data.map((e) => Map<String, dynamic>.from(e)).toList();

    _streamController.add(_broadcastList);
  }

  void addBroadcast(Map<String, dynamic> newItem) {
    _broadcastList.insert(0, newItem);
    _streamController.add(_broadcastList);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Broadcast"),
          content: const SingleChildScrollView(child: BroadcastFilter()),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Cari"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Broadcast"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await context.push<Map<String, dynamic>>(
            '/tambah-broadcast',
          );

          if (result != null) {
            addBroadcast(result);
          }
        },
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Broadcast',
                  style: theme.textTheme.displayLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola pengumuman resmi untuk warga.',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: DataTable2(
                            columnSpacing: 16,
                            columns: const [
                              DataColumn2(label: Text("Judul")),
                              DataColumn2(label: Text("Pengirim (ID)")),
                            ],
                            rows: data.map((item) {
                              return DataRow2(
                                onTap: () => context.push(
                                  '/detail-broadcast',
                                  extra: item,
                                ),
                                cells: [
                                  DataCell(
                                    Text(
                                      item['title'] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DataCell(
                                    Text((item['sender_id'] ?? '-').toString()),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}