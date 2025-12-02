// lib/screens/Broadcast/edit_broadcast.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/broadcast/tambah_broadcast_form.dart';

class EditBroadcastScreen extends StatelessWidget {
  final Map<String, dynamic> broadcastData;

  const EditBroadcastScreen({
    super.key,
    required this.broadcastData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Edit Broadcast"),
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
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perbarui Broadcast',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sesuaikan isi pengumuman sebelum dikirim ulang.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),

                  /// >>> PERBAIKAN DI SINI <<<
                  /// Tidak ada lagi field "sender", diganti ke sender_id (jika diperlukan)
                  /// Sesuai struktur tabel broadcast terbaru
                  TambahBroadcastForm(
                    initialData: {
                      "id": broadcastData["id"],
                      "title": broadcastData["title"],
                      "content": broadcastData["content"],
                      "sender_id": broadcastData["sender_id"], // FIXED
                      "image_url": broadcastData["image_url"],
                      "document_name": broadcastData["document_name"],
                      "document_url": broadcastData["document_url"],
                      "target_scope": broadcastData["target_scope"],
                    },
                    isEdit: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}