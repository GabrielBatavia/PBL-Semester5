// lib/widgets/broadcast/broadcast_filter.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BroadcastFilter extends StatefulWidget {
  const BroadcastFilter({super.key});

  @override
  State<BroadcastFilter> createState() => _BroadcastFilterState();
}

class _BroadcastFilterState extends State<BroadcastFilter> {
  String? selectedKategori;
  final TextEditingController _tanggalController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: "Nama Broadcast",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _tanggalController,
          decoration: InputDecoration(
            labelText: "Tanggal Dibuat",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          readOnly: true,
          onTap: () => _selectDate(context, _tanggalController),
        ),
      ],
    );
  }
}
