// lib/widgets/kegiatan/kegiatan_filter.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KegiatanFilter extends StatefulWidget {
  const KegiatanFilter({super.key});

  @override
  State<KegiatanFilter> createState() => _KegiatanFilterState();
}

class _KegiatanFilterState extends State<KegiatanFilter> {
  String? selectedKategori;
  final TextEditingController _tanggalController = TextEditingController();

  final List<String> kategori = [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya',
  ];

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd MMM yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(BuildContext context, String label,
      {Widget? suffixIcon}) {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: _decoration(context, "Nama Kegiatan"),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedKategori,
          hint: const Text("Pilih Kategori"),
          isExpanded: true,
          decoration: _decoration(context, "Kategori"),
          items: kategori
              .map(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
          onChanged: (newValue) => setState(() => selectedKategori = newValue),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _tanggalController,
          decoration: _decoration(
            context,
            "Tanggal Pelaksanaan",
            suffixIcon: Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
            ),
          ),
          readOnly: true,
          onTap: () => _selectDate(context, _tanggalController),
        ),
      ],
    );
  }
}
