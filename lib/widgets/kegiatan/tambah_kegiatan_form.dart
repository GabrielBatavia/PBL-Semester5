// lib/widgets/kegiatan/tambah_kegiatan_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class TambahKegiatanForm extends StatefulWidget {
  final Map<String, String>? initialData;

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

  /// Opsi kategori yang ditampilkan di UI
  final List<String> _kategoriOptions = const [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Kesehatan & Olahraga',
    'Pendidikan',
    'Lainnya',
  ];

  /// Mapping nilai kategori lama dari DB -> label UI
  String? _mapKategoriFromDb(String? raw) {
    if (raw == null) return null;
    switch (raw.toLowerCase()) {
      case 'rapat':
        return 'Komunitas & Sosial';
      case 'kebersihan':
        return 'Kebersihan & Keamanan';
      case 'olahraga':
        return 'Kesehatan & Olahraga';
      case 'pendidikan':
        return 'Pendidikan';
      case 'kegiatan':
      default:
        return 'Lainnya';
    }
  }

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;

    _namaController = TextEditingController(text: data?['nama']);
    _pjController = TextEditingController(text: data?['pj']);
    _tanggalController = TextEditingController(text: data?['tanggal']);
    _lokasiController = TextEditingController(text: data?['lokasi']);
    _deskripsiController = TextEditingController(text: data?['deskripsi']);

    // 🔥 Pastikan value dropdown hanya di-set jika ada di _kategoriOptions
    final mapped = _mapKategoriFromDb(data?['kategori']);
    if (mapped != null && _kategoriOptions.contains(mapped)) {
      _selectedKategori = mapped;
    } else {
      _selectedKategori = null;
    }
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menyimpan data kegiatan...')),
      );
      // TODO: kirim ke backend (pakai _selectedKategori sebagai kategori)
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
