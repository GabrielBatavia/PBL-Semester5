// lib/screens/Pemasukan/daftar_tagihan.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/bill_service.dart';

class DaftarTagihan extends StatefulWidget {
  const DaftarTagihan({super.key});

  @override
  State<DaftarTagihan> createState() => _DaftarTagihanState();
}

class _DaftarTagihanState extends State<DaftarTagihan> {
  List<Map<String, dynamic>> _bills = [];
  Set<int> _selectedBills = {}; // Menyimpan ID tagihan yang dipilih
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bills = await BillService.getBills();
      setState(() {
        _bills = bills;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _sendBillNotifications() async {
    if (_selectedBills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu tagihan untuk ditagih'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Kirim ke backend untuk diproses sebagai notifikasi
      await BillService.sendBillNotifications(_selectedBills.toList());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedBills.length} tagihan berhasil dikirim untuk dinotifikasi'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear selection
      setState(() {
        _selectedBills.clear();
      });

      // Reload data
      _loadBills();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _toggleSelection(int billId) {
    setState(() {
      if (_selectedBills.contains(billId)) {
        _selectedBills.remove(billId);
      } else {
        _selectedBills.add(billId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedBills.length == _bills.length) {
        _selectedBills.clear();
      } else {
        _selectedBills = _bills.map((bill) => bill['id'] as int).toSet();
      }
    });
  }

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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green;
      case 'belum_lunas':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return 'Lunas';
      case 'belum_lunas':
        return 'Belum Lunas';
      default:
        return status;
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
        title: const Text("Tagihan Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu-pemasukan'),
        ),
        actions: [
          if (_bills.isNotEmpty)
            IconButton(
              icon: Icon(
                _selectedBills.length == _bills.length 
                    ? Icons.check_box 
                    : Icons.check_box_outline_blank
              ),
              onPressed: _selectAll,
              tooltip: 'Pilih Semua',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBills,
          ),
        ],
      ),
      floatingActionButton: _selectedBills.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isSending ? null : _sendBillNotifications,
              backgroundColor: colorScheme.primary,
              icon: _isSending 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.notifications_active),
              label: Text(_isSending 
                  ? 'Mengirim...' 
                  : 'Tagih (${_selectedBills.length})'),
            )
          : FloatingActionButton.extended(
              onPressed: () => context.push('/tagih-iuran'),
              backgroundColor: colorScheme.secondary,
              icon: const Icon(Icons.add),
              label: const Text('Buat Tagihan Baru'),
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
                  'Daftar Tagihan Iuran',
                  style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih tagihan untuk dikirim notifikasi ke warga.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                if (_selectedBills.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_selectedBills.length} tagihan dipilih',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
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
                                        onPressed: _loadBills,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Coba Lagi'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _bills.isEmpty
                                ? const Center(child: Text('Belum ada tagihan.'))
                                : ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _bills.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final bill = _bills[index];
                                      final billId = bill['id'] as int;
                                      final isSelected = _selectedBills.contains(billId);
                                      
                                      return Card(
                                        elevation: isSelected ? 4 : 2,
                                        color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: isSelected ? colorScheme.primary : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: CheckboxListTile(
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            _toggleSelection(billId);
                                          },
                                          contentPadding: const EdgeInsets.all(16),
                                          title: Text(
                                            bill['family_name'] ?? 'Unknown',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text('${bill['category_name'] ?? ''} - ${bill['code']}'),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatCurrency(bill['amount']),
                                                style: TextStyle(
                                                  color: colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Periode: ${_formatDate(bill['period_start'])} - ${_formatDate(bill['period_end'])}',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          secondary: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(bill['status']).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              _getStatusLabel(bill['status']),
                                              style: TextStyle(
                                                color: _getStatusColor(bill['status']),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
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