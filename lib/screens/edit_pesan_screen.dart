// lib/screens/edit_pesan_screen.dart

import 'package:flutter/material.dart';
import '../theme/AppTheme.dart';

class EditPesanScreen extends StatefulWidget {
  const EditPesanScreen({super.key});

  @override
  State<EditPesanScreen> createState() => _EditPesanScreenState();
}

class _EditPesanScreenState extends State<EditPesanScreen> {
  String? _selectedStatus = 'Diterima';
  final List<String> _statuses = ['Diterima', 'Pending', 'Ditolak'];
  final TextEditingController _judulController =
      TextEditingController(text: 'titootit');
  final TextEditingController _deskripsiController =
      TextEditingController(text: 'mobile igmana bang');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Edit Aspirasi Warga"),
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
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Informasi Aspirasi Warga',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Judul Pesan
                  Text(
                    'Judul Pesan',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _judulController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan judul pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppTheme.highlightYellow),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.highlightYellow,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi Pesan
                  Text(
                    'Deskripsi Pesan',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan deskripsi pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppTheme.highlightYellow),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.highlightYellow,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Dropdown
                  Text(
                    'Status',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: _statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppTheme.highlightYellow),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Update Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika untuk menyimpan perubahan
                          // (sementara masih print)
                          // ignore: avoid_print
                          print('Judul: ${_judulController.text}');
                          // ignore: avoid_print
                          print('Deskripsi: ${_deskripsiController.text}');
                          // ignore: avoid_print
                          print('Status: $_selectedStatus');
                          Navigator.of(context).pop();
                        },
                        child: const Text('Update'),
                      ),
                    ),
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
