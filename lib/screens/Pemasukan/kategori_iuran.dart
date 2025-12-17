 // lib/screens/Pemasukan/kategori_iuran.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/fee_category_service.dart';

class KategoriIuran extends StatefulWidget {
  const KategoriIuran({super.key});

  @override
  State<KategoriIuran> createState() => _KategoriIuranState();
}

class _KategoriIuranState extends State<KategoriIuran> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await FeeCategoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleStatus(int id, int currentStatus) async {
    try {
      final newStatus = currentStatus == 1 ? 0 : 1;
      await FeeCategoryService.updateStatus(id, newStatus);
      _loadCategories(); // Reload to refresh list
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus == 1 ? 'Kategori diaktifkan' : 'Kategori dinonaktifkan'),
          backgroundColor: newStatus == 1 ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = 'bulanan';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Kategori Iuran'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Jenis',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'bulanan', child: Text('Iuran Bulanan')),
                    DropdownMenuItem(value: 'insidental', child: Text('Iuran Khusus')),
                    DropdownMenuItem(value: 'sukarela', child: Text('Sukarela')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Default',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Harap isi semua field'), backgroundColor: Colors.red),
                  );
                  return;
                }

                try {
                  await FeeCategoryService.createCategory(
                    name: nameController.text,
                    type: selectedType,
                    defaultAmount: double.parse(amountController.text),
                  );
                  Navigator.pop(context);
                  _loadCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori berhasil ditambahkan'), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Kategori Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu-pemasukan'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCategories,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori Iuran',
                  style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola kategori dan jenis iuran warga.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
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
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                                    const SizedBox(height: 16),
                                    Text('Gagal memuat data', style: theme.textTheme.titleLarge),
                                    const SizedBox(height: 8),
                                    Text(_errorMessage!, textAlign: TextAlign.center),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _loadCategories,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              )
                            : _categories.isEmpty
                                ? const Center(child: Text('Belum ada kategori iuran.'))
                                : ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _categories.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final category = _categories[index];
                                      return FeeCategoryCard(
                                        category: category,
                                        onToggleStatus: () => _toggleStatus(
                                          category['id'],
                                          category['is_active'] ?? 1,
                                        ),
                                      );
                                    },
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

class FeeCategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onToggleStatus;

  const FeeCategoryCard({
    super.key,
    required this.category,
    required this.onToggleStatus,
  });

  @override
  State<FeeCategoryCard> createState() => _FeeCategoryCardState();
}

class _FeeCategoryCardState extends State<FeeCategoryCard> {
  bool _isExpanded = false;

  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp 0';
    final numAmount = amount is double ? amount : double.tryParse(amount.toString()) ?? 0;
    final intAmount = numAmount.toInt();
    String numStr = intAmount.toString();
    String result = '';
    int counter = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      if (counter == 3) {
        result = '.$result';
        counter = 0;
      }
      result = numStr[i] + result;
      counter++;
    }
    return 'Rp $result';
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'bulanan': return 'Iuran Bulanan';
      case 'insidental': return 'Iuran Khusus';
      case 'sukarela': return 'Sukarela';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.category['is_active'] ?? 1;
    final cardColor = isActive == 1 ? const Color(0xFFB8E6B8) : const Color(0xFFFFB8B8);
    final borderColor = isActive == 1 ? Colors.green.shade700 : Colors.red.shade700;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.category['name'] ?? '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isActive == 1 ? 'Aktif' : 'Non-Aktif',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.category_outlined, size: 18, color: Colors.grey.shade800),
                      const SizedBox(width: 8),
                      Text(
                        _getTypeLabel(widget.category['type'] ?? ''),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.payments_outlined, size: 18, color: Colors.grey.shade800),
                      const SizedBox(width: 8),
                      Text(
                        'Nominal Default:',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatCurrency(widget.category['default_amount']),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0, width: double.infinity),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ElevatedButton.icon(
                  onPressed: widget.onToggleStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive == 1 ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(isActive == 1 ? Icons.block : Icons.check_circle),
                  label: Text(isActive == 1 ? 'Non-aktifkan Kategori' : 'Aktifkan Kategori'),), 
                  ), crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst, duration: const Duration(milliseconds: 300), ), ], ), ), ); } }