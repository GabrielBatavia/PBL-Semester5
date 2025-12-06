// lib/screens/Pemasukan/tagih_iuran_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/fee_category_service.dart';
import 'package:jawaramobile_1/services/bill_service.dart';
import 'package:intl/intl.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId;
  DateTime? _periodStart;
  DateTime? _periodEnd;
  double _amount = 0;
  bool _isLoading = false;
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await FeeCategoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kategori: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _selectPeriodStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _periodStart = picked;
      });
    }
  }

  void _selectPeriodEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _periodStart ?? DateTime.now(),
      firstDate: _periodStart ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _periodEnd = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _tagihIuran() async {
    if (_selectedCategoryId == null || _periodStart == null || _periodEnd == null || _amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua field"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final periodStartStr = DateFormat('yyyy-MM-dd').format(_periodStart!);
      final periodEndStr = DateFormat('yyyy-MM-dd').format(_periodEnd!);

      final result = await BillService.createBillsForAllFamilies(
        categoryId: _selectedCategoryId!,
        amount: _amount,
        periodStart: periodStartStr,
        periodEnd: periodEndStr,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Iuran berhasil ditagih'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/daftar-tagihan');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tagih Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu-pemasukan'),
        ),
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
                  'Tagih Iuran Warga',
                  style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Buat tagihan iuran untuk semua keluarga aktif.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
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
                    padding: const EdgeInsets.all(24.0),
                    child: _isLoadingCategories
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pilih Kategori Iuran', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<int>(
                                value: _selectedCategoryId,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Pilih kategori iuran',
                                ),
                                items: _categories.map((cat) {
                                  return DropdownMenuItem<int>(
                                    value: cat['id'],
                                    child: Text(cat['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategoryId = value;
                                    final cat = _categories.firstWhere((c) => c['id'] == value);
                                    _amount = (cat['default_amount'] as num).toDouble();
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Text('Nominal', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              TextField(
                                controller: TextEditingController(text: _amount.toString()),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixText: 'Rp ',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _amount = double.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Text('Periode Awal', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => _selectPeriodStart(context),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(_formatDate(_periodStart)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text('Periode Akhir', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => _selectPeriodEnd(context),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(_formatDate(_periodEnd)),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCategoryId = null;
                                          _periodStart = null;
                                          _periodEnd = null;
                                          _amount = 0;
                                        });
                                      },
                                      child: const Text('Reset'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _tagihIuran,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('Tagih Iuran', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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