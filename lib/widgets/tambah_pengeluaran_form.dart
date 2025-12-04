import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/services/expenses_service.dart';

class TambahPengeluaranForm extends StatefulWidget {
  const TambahPengeluaranForm({super.key});

  @override
  State<TambahPengeluaranForm> createState() => _TambahPengeluaranFormState();
}

class _TambahPengeluaranFormState extends State<TambahPengeluaranForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? selectedKategori;
  DateTime? _selectedDate;
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  final List<String> kategori = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Keamanan & Kebersihan',
    'Lain-lain',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nominalController.dispose();
    _tanggalController.dispose();
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
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isSubmitting) return;

      setState(() {
        _isSubmitting = true;
      });

      try {
        final nama = _namaController.text.trim();
        final kategoriVal = selectedKategori ?? '';
        final nominal = double.parse(_nominalController.text.replaceAll('.', ''));

        // Add debug print
        debugPrint('=== SUBMIT FORM ===');
        debugPrint('Name: $nama');
        debugPrint('Category: $kategoriVal');
        debugPrint('Amount: $nominal');
        debugPrint('Selected Date: $_selectedDate');

        if (_selectedDate == null) {
          throw Exception('Tanggal belum dipilih');
        }

        // Format date to YYYY-MM-DD for backend
        final dateFormatted = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        debugPrint('Date formatted: $dateFormatted');

        // Call backend API
        debugPrint('Calling API...');
        final result = await ExpenseService.createExpense(
          name: nama,
          category: kategoriVal,
          amount: nominal,
          date: dateFormatted,
          proofImageUrl: null,
        );

        debugPrint('API response: $result');

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengeluaran berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to pengeluaran screen
        debugPrint('Navigating back...');
        context.go('/pengeluaran');

      } catch (e) {
        debugPrint('ERROR: $e');
        
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = theme.colorScheme.primary.withOpacity(0.05);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Nama Pengeluaran
          TextFormField(
            controller: _namaController,
            decoration: InputDecoration(
              labelText: 'Nama Pengeluaran',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.shopping_bag_outlined),
              filled: true,
              fillColor: fillColor,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama pengeluaran tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 2. Kategori
          DropdownButtonFormField<String>(
            value: selectedKategori,
            hint: const Text("Pilih Kategori"),
            decoration: InputDecoration(
              labelText: "Kategori",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: fillColor,
            ),
            items: kategori
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
            onChanged: (newValue) =>
                setState(() => selectedKategori = newValue),
            validator: (value) {
              if (value == null) {
                return 'Silakan pilih kategori';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 3. Nominal
          TextFormField(
            controller: _nominalController,
            decoration: InputDecoration(
              labelText: 'Nominal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.monetization_on_outlined),
              prefixText: 'Rp ',
              filled: true,
              fillColor: fillColor,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nominal tidak boleh kosong';
              }
              if (int.tryParse(value.replaceAll('.', '')) == null) {
                return 'Nominal harus berupa angka';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 4. Tanggal
          TextFormField(
            controller: _tanggalController,
            decoration: InputDecoration(
              labelText: 'Tanggal Pengeluaran',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              filled: true,
              fillColor: fillColor,
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          Text(
            'Bukti Pengeluaran (Opsional)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildReceiptPicker(context),
          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptPicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.gallery),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade100,
        ),
        child: _receiptImage == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 36,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text('Tap untuk menambahkan foto nota'),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_receiptImage!, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source);
      if (picked != null) {
        setState(() => _receiptImage = File(picked.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }
}
