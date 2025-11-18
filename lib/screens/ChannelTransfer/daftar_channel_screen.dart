// lib/screens/ChannelTransfer/daftar_channel_screen.dart
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DaftarChannelScreen extends StatelessWidget {
  const DaftarChannelScreen({super.key});

  // Data dummy
  final List<Map<String, String>> _rows = const [
    {"nama": "QRIS Resmi RT 08", "tipe": "qris", "an": "RW 08 Karangploso"},
    {"nama": "BCA", "tipe": "bank", "an": "Jose"},
    {"nama": "OVO", "tipe": "ewallet", "an": "23234"},
    {
      "nama": "Transfer via BCA",
      "tipe": "bank",
      "an": "RT Jawara Karangploso"
    },
  ];

  Widget _typeChip(BuildContext context, String t) {
    final cs = Theme.of(context).colorScheme;
    Color bg;
    Color fg;

    switch (t) {
      case 'bank':
        bg = cs.primary.withOpacity(.12);
        fg = cs.primary;
        break;
      case 'ewallet':
        bg = cs.secondary.withOpacity(.35);
        fg = cs.onSecondary;
        break;
      case 'qris':
        bg = Colors.white;
        fg = cs.primary;
        break;
      default:
        bg = cs.surfaceVariant;
        fg = cs.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        t,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: fg,
        ),
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
        title: const Text("Channel Transfer"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: filter (opsional)
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tambah-channel'),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add_link),
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
                Text(
                  'Daftar Channel Transfer',
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Atur rekening, e-wallet, dan QRIS resmi untuk pembayaran.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
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
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        headingRowColor: MaterialStateProperty.all(
                          colorScheme.primary.withOpacity(0.05),
                        ),
                        headingTextStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        columns: const [
                          DataColumn2(label: Text('Nama Channel')),
                          DataColumn2(label: Text('Tipe')),
                        ],
                        rows: _rows.map((r) {
                          return DataRow2(
                            onTap: () {
                              // TODO: arahkan ke detail channel jika sudah ada
                              context.push('/tambah-channel');
                            },
                            cells: [
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      r['nama']!,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "A/N ${r['an']!}",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(_typeChip(context, r['tipe']!)),
                            ],
                          );
                        }).toList(),
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
