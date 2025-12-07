import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile_1/services/report_service.dart';
import 'package:open_file/open_file.dart';

class CetakLaporanForm extends StatefulWidget {
  const CetakLaporanForm({super.key});

  @override
  State<CetakLaporanForm> createState() => _CetakLaporanFormState();
}

class _CetakLaporanFormState extends State<CetakLaporanForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedJenisLaporan;
  DateTime? _dariTanggal;
  DateTime? _sampaiTanggal;
  bool _isGenerating = false;

  final List<Map<String, String>> _jenisLaporan = [
    {'value': 'pemasukan', 'label': 'Pemasukan'},
    {'value': 'pengeluaran', 'label': 'Pengeluaran'},
    {'value': 'semua', 'label': 'Semua (Pemasukan & Pengeluaran)'},
  ];

  Future<void> _selectDate(BuildContext context, bool isDari) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDari ? (_dariTanggal ?? DateTime.now()) : (_sampaiTanggal ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDari) {
          _dariTanggal = picked;
        } else {
          _sampaiTanggal = picked;
        }
      });
    }
  }

  Future<void> _submitCetak() async {
    if (_formKey.currentState!.validate()) {
      if (_dariTanggal == null || _sampaiTanggal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih tanggal'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_sampaiTanggal!.isBefore(_dariTanggal!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tanggal akhir harus setelah tanggal awal'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isGenerating = true;
      });

      try {
        final startDate = DateFormat('yyyy-MM-dd').format(_dariTanggal!);
        final endDate = DateFormat('yyyy-MM-dd').format(_sampaiTanggal!);

        final filePath = await ReportService.generateReport(
          reportType: _selectedJenisLaporan!,
          startDate: startDate,
          endDate: endDate,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Laporan berhasil diunduh: $filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Buka',
              textColor: Colors.white,
              onPressed: () {
                OpenFile.open(filePath);
              },
            ),
          ),
        );

        // Reset form
        setState(() {
          _selectedJenisLaporan = null;
          _dariTanggal = null;
          _sampaiTanggal = null;
        });
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat laporan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isGenerating = false;
        });
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
          DropdownButtonFormField<String>(
            value: _selectedJenisLaporan,
            hint: const Text("Pilih Jenis Laporan"),
            decoration: InputDecoration(
              labelText: "Jenis Laporan",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: fillColor,
            ),
            items: _jenisLaporan.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(item['label']!),
              );
            }).toList(),
            onChanged: (newValue) => setState(() => _selectedJenisLaporan = newValue),
            validator: (value) => value == null ? 'Silakan pilih jenis laporan' : null,
          ),
          const SizedBox(height: 20),

          InkWell(
            onTap: () => _selectDate(context, true),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Dari Tanggal",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: const Icon(Icons.calendar_today),
                filled: true,
                fillColor: fillColor,
              ),
              child: Text(
                _dariTanggal == null
                    ? 'Pilih tanggal'
                    : DateFormat('dd MMM yyyy').format(_dariTanggal!),
                style: TextStyle(
                  color: _dariTanggal == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          InkWell(
            onTap: () => _selectDate(context, false),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Sampai Tanggal",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: const Icon(Icons.calendar_today),
                filled: true,
                fillColor: fillColor,
              ),
              child: Text(
                _sampaiTanggal == null
                    ? 'Pilih tanggal'
                    : DateFormat('dd MMM yyyy').format(_sampaiTanggal!),
                style: TextStyle(
                  color: _sampaiTanggal == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: _isGenerating ? null : _submitCetak,
            icon: _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.download),
            label: Text(_isGenerating ? 'Membuat Laporan...' : 'Download PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
