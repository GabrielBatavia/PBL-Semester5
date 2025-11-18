// lib/screens/ManajemenPengguna/tambah_pengguna_screen.dart

import 'package:flutter/material.dart';

class TambahPenggunaScreen extends StatefulWidget {
  const TambahPenggunaScreen({super.key});

  @override
  State<TambahPenggunaScreen> createState() => _TambahPenggunaScreenState();
}

class _TambahPenggunaScreenState extends State<TambahPenggunaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _hpCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();
  String? _role;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengguna disimpan')),
      );
      Navigator.of(context).pop();
    }
  }

  void _reset() {
    _formKey.currentState?.reset();
    _namaCtrl.clear();
    _emailCtrl.clear();
    _hpCtrl.clear();
    _pwdCtrl.clear();
    _pwd2Ctrl.clear();
    setState(() => _role = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Tambah Akun Pengguna"),
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
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
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
                    Text(
                      'Data Akun Baru',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      "Nama Lengkap",
                      _namaCtrl,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    _field(
                      "Email",
                      _emailCtrl,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? "Email tidak valid"
                          : null,
                    ),
                    _field(
                      "Nomor HP",
                      _hpCtrl,
                      keyboard: TextInputType.phone,
                    ),
                    _field(
                      "Password",
                      _pwdCtrl,
                      obscure: true,
                      validator: (v) =>
                          (v == null || v.length < 6) ? "Min. 6 karakter" : null,
                    ),
                    _field(
                      "Konfirmasi Password",
                      _pwd2Ctrl,
                      obscure: true,
                      validator: (v) =>
                          v == _pwdCtrl.text ? null : "Tidak sama",
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _role,
                      hint: const Text("-- Pilih Role --"),
                      items: const ["Admin", "Community Head", "Warga"]
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _role = v),
                      decoration: const InputDecoration(
                        labelText: "Role",
                      ),
                      validator: (v) => v == null ? "Pilih role" : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Simpan"),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _reset,
                          child: const Text("Reset"),
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

  Widget _field(
    String label,
    TextEditingController c, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
