import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/broadcast_service.dart';

class DetailBroadcastScreen extends StatelessWidget {
  final Map<String, dynamic> broadcastData;

  const DetailBroadcastScreen({super.key, required this.broadcastData});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus broadcast ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus"),
              onPressed: () async {
                Navigator.pop(dialogContext);

                final id = broadcastData['id'];
                final success = await BroadcastService.deleteBroadcast(id);

                if (context.mounted) {
                  if (success) {
                    context.pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Broadcast berhasil dihapus")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menghapus broadcast")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String title = broadcastData['title']?.toString() ?? '-';
    final String content = broadcastData['content']?.toString() ?? '-';

    // FIX: gunakan sender_id karena sender sudah dihapus
    final String senderId = broadcastData['sender_id']?.toString() ?? '-';

    final String createdAt =
        broadcastData['created_at']?.toString().replaceAll('T', ' ') ?? '-';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detail Broadcast"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title,
                    style: theme.textTheme.displayLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text("Broadcast RW / RT",
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 20),

                // Card detail
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildRow(context, "Judul", title),
                        const Divider(),
                        _buildRow(context, "Pengirim (User ID)", senderId),
                        const Divider(),
                        _buildRow(context, "Tanggal Publikasi", createdAt),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text("Isi Broadcast",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Isi broadcast
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(content, style: theme.textTheme.bodyMedium),
                ),

                const SizedBox(height: 32),

                // Tombol aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Hapus"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () => _confirmDelete(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text("Edit"),
                        onPressed: () {
                          context.push(
                            '/edit-broadcast',
                            extra: broadcastData,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}