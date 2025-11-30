import 'package:flutter/material.dart';

import '../models/financial_model.dart';
import '../services/financial_service.dart';

// Screen untuk mencatat transaksi Pemasukan
class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = FinancialService();

  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitIncome() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unik
      description: _descController.text,
      amount: double.parse(_amountController.text),
      type: TransactionType.income,
      date: DateTime.now(),
    );

    try {
      // #14 RESTful API (Async): Simulasi kirim data ke API
      await _service.postTransaction(newTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pemasukan berhasil dicatat! Laporan di-update.'),
          ),
        );

        _descController.clear();
        _amountController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal mencatat: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Form Input Pemasukan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Divider(height: 25),

                // Input Deskripsi
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Pemasukan (e.g. Iuran bulanan, Donasi)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description, color: Colors.green),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                ),
                const SizedBox(height: 15),

                // Input Jumlah Uang
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Uang (Rp)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value!.isEmpty ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0)
                      ? 'Masukkan jumlah yang valid (min. Rp 1)'
                      : null,
                ),
                const SizedBox(height: 30),

                // Tombol Submit
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitIncome,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Memproses...' : 'Catat Pemasukan',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
