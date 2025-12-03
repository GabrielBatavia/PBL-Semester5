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

  // ===============================
  //  LOAD DATA DARI BACKEND
  // ===============================
  Future<void> _loadBroadcast() async {
    try {
      final raw = await BroadcastService.getBroadcastList();
      _broadcastList = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      _streamController.add(_broadcastList);
    } catch (e) {
      _streamController.add([]);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal memuat broadcast: $e")));
      }
    }
  }

  // untuk menambahkan broadcast baru dari halaman tambah
  void addBroadcast(Map<String, dynamic> newItem) {
    _broadcastList.insert(0, newItem);
    _streamController.add(_broadcastList);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter Broadcast"),
        content: const SingleChildScrollView(child: BroadcastFilter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cari"),
          ),
        ],
      ),
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
            onPressed: _showFilterDialog,
          ),
        ],
      ),

      // ===============================
      //  BUTTON TAMBAH BROADCAST
      // ===============================
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await context.pushNamed<Map<String, dynamic>>(
            'tambah-broadcast',
          );
          if (result != null) addBroadcast(result);
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
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daftar Broadcast',
                    style: theme.textTheme.displayLarge!
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  'Kelola pengumuman resmi untuk seluruh warga.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),

                // ===============================
                //  TABEL BROADCAST
                // ===============================
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final data = snapshot.data!;
                          if (data.isEmpty) {
                            return const Center(
                                child: Text("Belum ada broadcast"));
                          }

                          return DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            headingRowColor: MaterialStateProperty.all(
                              colorScheme.primary.withOpacity(0.05),
                            ),
                            headingTextStyle: theme.textTheme.bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary),

                            columns: const [
                              DataColumn2(label: Text('Judul')),
                              DataColumn2(label: Text('Pengirim (ID)')),
                            ],

                            rows: data.map((item) {
                              return DataRow2(
                                onTap: () {
                                  context.pushNamed(
                                    'detail-broadcast',
                                    extra: item,
                                  );
                                },
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
                          );
                        },
                      ),
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