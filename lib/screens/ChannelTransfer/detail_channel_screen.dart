// lib/screens/ChannelTransfer/detail_channel_screen.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/models/payment_channel.dart';

class DetailChannelScreen extends StatelessWidget {
  final PaymentChannel channelData;

  const DetailChannelScreen({super.key, required this.channelData});

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isHighlight
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeChip(BuildContext context, String t) {
    final cs = Theme.of(context).colorScheme;
    Color bg;
    Color fg;

    final type = t.toLowerCase();
    switch (type) {
      case 'bank':
      case 'transfer':
        bg = cs.primary.withOpacity(.12);
        fg = cs.primary;
        break;
      case 'ewallet':
        bg = cs.secondary.withOpacity(.35);
        fg = cs.onSecondary;
        break;
      case 'qris':
        bg = Colors.orange.withOpacity(.15);
        fg = Colors.orange[800]!;
        break;
      default:
        bg = cs.surfaceVariant;
        fg = cs.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: fg,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detail Channel Transfer"),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  channelData.name,
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _typeChip(context, channelData.type),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          "Nama Channel",
                          channelData.name,
                          isHighlight: true,
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Tipe",
                          channelData.type.toUpperCase(),
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Nama Pemilik (A/N)",
                          channelData.accountName ?? '-',
                        ),
                        const Divider(height: 1),
                        _buildDetailRow(
                          context,
                          "Nomor Rekening/Akun",
                          channelData.accountNumber ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (channelData.type.toLowerCase() == 'qris') ...[
                  Text(
                    'QR Code',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2_outlined,
                        size: 64,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}