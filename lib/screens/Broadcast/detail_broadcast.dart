// lib/screens/Broadcast/detail_broadcast.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/broadcast_service.dart';

class DetailBroadcastScreen extends StatelessWidget {
  final Map<String, dynamic> broadcastData;
  const DetailBroadcastScreen({super.key, required this.broadcastData});

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Yakin ingin menghapus broadcast ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(dCtx, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (ok == true) {
      final id = broadcastData['id'];
      final success = await BroadcastService.deleteBroadcast(id);
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Broadcast dihapus")));
          context.pop(true);
        }
      } else {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal hapus")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = broadcastData['title'] ?? '-';
    final senderId = broadcastData['sender_id']?.toString() ?? '-';
    final content = broadcastData['content'] ?? '-';
    final createdAt = broadcastData['created_at'] ?? '-';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Detail Broadcast"), backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(title, style: theme.textTheme.displayLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text("Broadcast RT / RW", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.98), borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Judul"), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Pengirim (ID)"), Text(senderId, style: const TextStyle(fontWeight: FontWeight.bold))]),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Tanggal"), Text(createdAt.toString(), style: const TextStyle(fontWeight: FontWeight.bold))]),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Text("Isi Broadcast", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.96), borderRadius: BorderRadius.circular(12)), child: Text(content, style: theme.textTheme.bodyMedium)),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: () => _confirmDelete(context), icon: const Icon(Icons.delete_outline), label: const Text("Hapus"), style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(onPressed: () => GoRouter.of(context).push('/edit-broadcast', extra: broadcastData), icon: const Icon(Icons.edit_outlined), label: const Text("Edit"))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}