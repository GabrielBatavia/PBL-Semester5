import 'package:flutter/material.dart';
import '../../models/house_model.dart';
import '../../services/house_service.dart';

class HouseFormPage extends StatefulWidget {
  final HouseModel? existing;

  const HouseFormPage({super.key, this.existing});

  @override
  State<HouseFormPage> createState() => _HouseFormPageState();
}

class _HouseFormPageState extends State<HouseFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _addressController;
  late TextEditingController _areaController;

  String _status = "terisi";

  @override
  void initState() {
    super.initState();

    _addressController =
        TextEditingController(text: widget.existing?.address ?? "");
    _areaController =
        TextEditingController(text: widget.existing?.area ?? "");


    final allowedStatus = ["terisi", "kosong"];

    _status = widget.existing?.status ?? "terisi";

    if (!allowedStatus.contains(_status)) {
      _status = "terisi"; 
    }
    
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "address": _addressController.text.trim(),
      "area": _areaController.text.trim(),
      "status": _status,
    };

    bool ok;

    if (widget.existing == null) {
      ok = await HouseService.instance.createHouse(body);
    } else {
      ok = await HouseService.instance.updateHouse(widget.existing!.id, body);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Berhasil disimpan" : "Ber-proses")),
    );

    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? "Edit Rumah" : "Tambah Rumah"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ALAMAT
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Alamat Rumah",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Alamat wajib diisi" : null,
                  ),

                  const SizedBox(height: 16),

                  // AREA
                  TextFormField(
                    controller: _areaController,
                    decoration: InputDecoration(
                      labelText: "Area",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // STATUS
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: InputDecoration(
                      labelText: "Status Rumah",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "terisi",
                        child: Text("Terisi"),
                      ),
                      DropdownMenuItem(
                        value: "kosong",
                        child: Text("Kosong"),
                      ),
                    ],
                    onChanged: (v) => setState(() => _status = v!),
                  ),

                  const SizedBox(height: 24),

                  // BUTTON SAVE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        editing ? "Simpan Perubahan" : "Tambah Rumah",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
