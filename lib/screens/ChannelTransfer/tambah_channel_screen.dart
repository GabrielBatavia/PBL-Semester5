// lib/screens/ChannelTransfer/tambah_channel_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/payment_channel_service.dart';

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
  final _bankNameCtrl = TextEditingController();
  String? _tipe; // bank/ewallet/qris
  bool _isSubmitting = false;

  void _reset() {
    _formKey.currentState?.reset();
    _namaCtrl.clear();
    _nomorCtrl.clear();
    _pemilikCtrl.clear();
    _bankNameCtrl.clear();
    setState(() => _tipe = null);
  }

  Future<void> _simpan() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await PaymentChannelService.createChannel(
        name: _namaCtrl.text.trim(),
        type: _tipe!,
        accountName: _pemilikCtrl.text.trim(),
        accountNumber: _nomorCtrl.text.trim(),
        bankName: _bankNameCtrl.text.trim().isEmpty ? null : _bankNameCtrl.text.trim(),
        qrisImageUrl: null, // TODO: upload image first if needed
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Channel berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/daftar-channel');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
    _bankNameCtrl.dispose();
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
                            value: 'transfer', child: Text('Bank Transfer')),
                        DropdownMenuItem(
                            value: 'ewallet', child: Text('E-Wallet')),
                        DropdownMenuItem(
                            value: 'qris', child: Text('QRIS')),
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
                      "Nama Pemilik (A/N)",
                      _pemilikCtrl,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    if (_tipe == 'transfer')
                      _field(
                        "Nama Bank (Opsional)",
                        _bankNameCtrl,
                      ),
                    _uploadPlaceholder("QR (Opsional)"),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _simpan,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Simpan"),
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