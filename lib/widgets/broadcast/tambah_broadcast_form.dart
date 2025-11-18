// lib/widgets/broadcast/tambah_broadcast_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class TambahBroadcastForm extends StatefulWidget {
  final Map<String, String>? initialData;

  const TambahBroadcastForm({super.key, this.initialData});

  @override
  State<TambahBroadcastForm> createState() => _TambahBroadcastFormState();
}

class _TambahBroadcastFormState extends State<TambahBroadcastForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _judulBroadcast;
  late TextEditingController _isiBroadcast;
  late TextEditingController _tanggalController;
  late TextEditingController _pengirim;

  File? _photo;
  PlatformFile? _document;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _judulBroadcast = TextEditingController(text: data?['judul']);
    _isiBroadcast = TextEditingController(text: data?['isi']);
    _tanggalController = TextEditingController(text: data?['tanggal']);
    _pengirim = TextEditingController(text: data?['pengirim']);
  }

  @override
  void dispose() {
    _judulBroadcast.dispose();
    _tanggalController.dispose();
    _pengirim.dispose();
    _isiBroadcast.dispose();
    super.dispose();
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

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _document = result.files.first;
      });
    }
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menyimpan data broadcast...')),
      );
      // TODO: kirim data ke backend
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
            controller: _judulBroadcast,
            decoration: _decoration('Judul Broadcast'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Judul broadcast tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _pengirim,
            decoration: _decoration('Pengirim'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Pengirim tidak boleh kosong'
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
            controller: _isiBroadcast,
            decoration: _decoration('Isi Broadcast'),
            maxLines: 4,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Isi broadcast tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            'Upload Foto (Opsional)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildImagePicker(context),
          const SizedBox(height: 24),
          Text(
            'Upload Dokumen (Opsional)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildDocumentPicker(context),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
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

  Widget _buildDocumentPicker(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      icon: Icon(
        Icons.attach_file,
        color: theme.colorScheme.primary,
      ),
      label: Text(
        _document == null ? 'Pilih Dokumen (PDF/DOC)' : _document!.name,
      ),
      onPressed: _pickDocument,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: theme.textTheme.bodyLarge,
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.4),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
