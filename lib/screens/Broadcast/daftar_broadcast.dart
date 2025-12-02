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
    try {
      final List<dynamic> raw = await BroadcastService.getBroadcastList();
      _broadcastList = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      _streamController.add(_broadcastList);
    } catch (e) {
      _streamController.add([]);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal load broadcast: $e")));
      }
    }
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
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Filter Broadcast"),
          content: const SingleChildScrollView(child: BroadcastFilter()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cari"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result =
              await context.pushNamed<Map<String, dynamic>>('tambah-broadcast');
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
                  style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final data = snapshot.data!;
                        if (data.isEmpty) {
                          return const Center(child: Text("Belum ada broadcast"));
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Material(
                            color: Colors.white,
                            child: DataTable2(
                              columnSpacing: 16,
                              columns: const [
                                DataColumn2(label: Text("Judul")),
                                DataColumn2(label: Text("Pengirim (ID)")),
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
                                    DataCell(Text(
                                      item['title'] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    DataCell(Text(
                                        (item['sender_id'] ?? '-').toString())),
                                  ],
                                );
                              }).toList(),
                            ),
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