// lib/widgets/kegiatan/tambah_kegiatan_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';
import 'package:jawaramobile_1/services/kegiatan_service.dart';

class TambahKegiatanForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const TambahKegiatanForm({super.key, this.initialData});

  @override
  State<TambahKegiatanForm> createState() => _TambahKegiatanFormState();
}

class _TambahKegiatanFormState extends State<TambahKegiatanForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _pjController;
  late TextEditingController _tanggalController;
  late TextEditingController _lokasiController;
  late TextEditingController _deskripsiController;
  String? _selectedKategori;
  File? _photo;

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _kategoriOptions = [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Kesehatan & Olahraga',
    'Pendidikan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _namaController = TextEditingController(text: data?['nama']);
    _pjController = TextEditingController(text: data?['pj']);
    _tanggalController = TextEditingController(text: data?['tanggal']);
    _lokasiController = TextEditingController(text: data?['lokasi']);
    _deskripsiController = TextEditingController(text: data?['deskripsi']);
    _selectedKategori = data?['kategori'];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pjController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd MMM yyyy').format(picked);
      setState(() {
        _tanggalController.text = formattedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _photo = File(pickedImage.path);
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.initialData != null;
    final kegiatanId = int.tryParse(widget.initialData?['id'] ?? '0');

    final Map<String, dynamic> data = {
      'nama': _namaController.text.trim(),
      'kategori': _selectedKategori,
      'pj': _pjController.text.trim(),
      'lokasi': _lokasiController.text.trim(),
      'tanggal': _tanggalController.text.trim(),
      'deskripsi': _deskripsiController.text.trim(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menyimpan data...')),
    );

    bool success = false;

    if (isEdit) {
      success = await KegiatanService.update(kegiatanId!, data);
    } else {
      success = await KegiatanService.create(data);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context); // balik ke list / detail
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? 'Kegiatan berhasil diperbarui!'
              : 'Kegiatan berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? 'Gagal memperbarui kegiatan'
              : 'Gagal menambahkan kegiatan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _decoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _namaController,
            decoration: _decoration('Nama Kegiatan'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama kegiatan tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text("Pilih Kategori"),
            decoration: _decoration("Kategori"),
            items: _kategoriOptions
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
            onChanged: (newValue) =>
                setState(() => _selectedKategori = newValue),
            validator: (value) =>
                value == null ? 'Silakan pilih kategori' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _pjController,
            decoration: _decoration('Penanggung Jawab'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Penanggung jawab tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lokasiController,
            decoration: _decoration('Lokasi'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Lokasi tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _tanggalController,
            decoration: _decoration(
              'Tanggal Pelaksanaan',
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) =>
                value == null || value.isEmpty ? 'Tanggal harus diisi' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _deskripsiController,
            decoration: _decoration('Deskripsi'),
            maxLines: 4,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Deskripsi tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            'Upload Dokumentasi (Opsional)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildImagePicker(context),
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _photo == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: AppTheme.primaryOrange,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap untuk tambah foto',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _photo!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ),
    );
  }
}
