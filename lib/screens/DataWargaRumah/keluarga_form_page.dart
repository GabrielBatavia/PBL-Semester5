import 'package:flutter/material.dart';
import '../../services/family_service.dart';
import '../../services/house_service.dart';
import '../../models/family_model.dart';
import '../../models/house_model.dart';

class FamilyFormPage extends StatefulWidget {
  final FamilyModel? existing;

  const FamilyFormPage({super.key, this.existing});

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final statusController = TextEditingController();

  List<HouseModel> houses = [];
  int? selectedHouseId;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadHouses();

    if (widget.existing != null) {
      nameController.text = widget.existing!.name;
      selectedHouseId = widget.existing!.houseId;
      selectedStatus = widget.existing!.status; // PRELOAD STATUS
    }
  }

  Future<void> _loadHouses() async {
    houses = await HouseService.instance.fetchHouses();
    setState(() {});
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    bool ok;

    if (widget.existing == null) {
      ok = await FamilyService.instance.createFamily(
        name: nameController.text,
        houseId: selectedHouseId,
        status: selectedStatus,
      );
    } else {
      ok = await FamilyService.instance.updateFamily(
        id: widget.existing!.id,
        name: nameController.text,
        houseId: selectedHouseId,
        status: selectedStatus,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Berhasil disimpan" : "Gagal menyimpan")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Keluarga" : "Tambah Keluarga"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NAMA KELUARGA
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Keluarga"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 16),

              // STATUS
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(
                      value: "aktif", child: Text("Aktif")),
                  DropdownMenuItem(
                      value: "tidak aktif", child: Text("Tidak Aktif")),
                ],
                onChanged: (v) {
                  setState(() {
                    selectedStatus = v;
                  });
                },
                validator: (v) =>
                    v == null ? "Status wajib dipilih" : null,
              ),

              const SizedBox(height: 16),

              // DROPDOWN RUMAH
              DropdownButtonFormField<int>(
                value: selectedHouseId,
                decoration: const InputDecoration(labelText: "Rumah (Address)"),
                items: houses
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: Text("${e.address}"),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedHouseId = v;
                  });
                },
                validator: (v) =>
                    v == null ? "Pilih rumah terlebih dahulu" : null,
              ),

              const SizedBox(height: 12),

              // PREVIEW ADDRESS OTOMATIS
              if (selectedHouseId != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Alamat dipilih: ${houses.firstWhere((e) => e.id == selectedHouseId!).address}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? "Update" : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
