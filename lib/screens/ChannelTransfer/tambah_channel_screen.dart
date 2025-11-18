// lib/screens/ChannelTransfer/tambah_channel_screen.dart

import 'package:flutter/material.dart';

class TambahChannelScreen extends StatefulWidget {
  const TambahChannelScreen({super.key});

  @override
  State<TambahChannelScreen> createState() => _TambahChannelScreenState();
}

class _TambahChannelScreenState extends State<TambahChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _nomorCtrl = TextEditingController();
  final _pemilikCtrl = TextEditingController();
  final _catatanCtrl = TextEditingController();
  String? _tipe; // bank/ewallet/qris

  void _reset() {
    _formKey.currentState?.reset();
    _namaCtrl.clear();
    _nomorCtrl.clear();
    _pemilikCtrl.clear();
    _catatanCtrl.clear();
    setState(() => _tipe = null);
  }

  void _simpan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO: simpan ke server / database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Channel disimpan')),
    );
    Navigator.of(context).pop();
  }

  Widget _field(
    String label,
    TextEditingController c, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          // gunakan InputDecorationTheme dari AppTheme (tanpa border manual)
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _uploadPlaceholder(String label) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload_outlined),
              const SizedBox(width: 8),
              Text(
                "Upload gambar (png/jpg) – placeholder",
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nomorCtrl.dispose();
    _pemilikCtrl.dispose();
    _catatanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Buat Transfer Channel"),
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
            padding: const EdgeInsets.all(20),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(
                      "Nama Channel",
                      _namaCtrl,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _tipe,
                      hint: const Text("-- Pilih Tipe --"),
                      items: const [
                        DropdownMenuItem(
                            value: 'bank', child: Text('bank')),
                        DropdownMenuItem(
                            value: 'ewallet', child: Text('ewallet')),
                        DropdownMenuItem(
                            value: 'qris', child: Text('qris')),
                      ],
                      onChanged: (v) => setState(() => _tipe = v),
                      decoration: const InputDecoration(
                        labelText: "Tipe",
                      ),
                      validator: (v) => v == null ? "Pilih tipe" : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      "Nomor Rekening / Akun",
                      _nomorCtrl,
                      keyboard: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    _field(
                      "Nama Pemilik",
                      _pemilikCtrl,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    _uploadPlaceholder("QR"),
                    _uploadPlaceholder("Thumbnail"),
                    TextFormField(
                      controller: _catatanCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Catatan (Opsional)",
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _simpan,
                            child: const Text("Simpan"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _reset,
                            child: const Text("Reset"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
