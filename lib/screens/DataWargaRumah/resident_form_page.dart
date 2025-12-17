import 'package:flutter/material.dart';
import '../../models/family_model.dart';
import '../../models/resident_model.dart';
import '../../services/family_service.dart';
import '../../services/resident_service.dart';

class FormResidentPage extends StatefulWidget {
  final ResidentModel? existingData;

  const FormResidentPage({super.key, this.existingData});

  @override
  State<FormResidentPage> createState() => _FormResidentPageState();
}

class _FormResidentPageState extends State<FormResidentPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final jobController = TextEditingController();
  final birthController = TextEditingController();

  String? gender;
  int? selectedFamilyId;

  List<FamilyModel> families = [];

  bool get isEdit => widget.existingData != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final r = widget.existingData!;
      nameController.text = r.name;
      nikController.text = r.nik ?? "";
      jobController.text = r.job ?? "";
      birthController.text = r.birthDate ?? "";
      gender = r.gender;
      selectedFamilyId = r.familyId;
    }

    _loadFamilies();
  }

  Future<void> _loadFamilies() async {
    families = await FamilyService.instance.fetchFamilies();
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final resident = ResidentModel(
      id: isEdit ? widget.existingData!.id : 0,
      name: nameController.text,
      nik: nikController.text,
      birthDate: birthController.text,
      job: jobController.text,
      gender: gender,
      familyId: selectedFamilyId,
      userId: null,
    );

    bool success;

    if (isEdit) {
      success = await ResidentService.instance.updateResident(
        resident.id,
        resident,
      );
    } else {
      success = await ResidentService.instance.createResident(resident);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? isEdit
                  ? "Data warga berhasil diperbarui"
                  : "Data warga berhasil ditambahkan"
              : "Gagal menyimpan data warga",
        ),
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Data Warga" : "Tambah Data Warga"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: families.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Nama"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Nama wajib diisi" : null,
                    ),

                    TextFormField(
                      controller: nikController,
                      decoration: const InputDecoration(labelText: "NIK"),
                    ),

                    TextFormField(
                      controller: jobController,
                      decoration: const InputDecoration(labelText: "Pekerjaan"),
                    ),

                    TextFormField(
                      controller: birthController,
                      decoration:
                          const InputDecoration(labelText: "Tanggal Lahir"),
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                          initialDate: DateTime(2000),
                        );
                        if (picked != null) {
                          birthController.text =
                              picked.toIso8601String().split("T")[0];
                        }
                      },
                    ),

                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration:
                          const InputDecoration(labelText: "Jenis Kelamin"),
                      items: const [
                        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "P", child: Text("Perempuan")),
                      ],
                      onChanged: (v) => setState(() => gender = v),
                    ),

                    DropdownButtonFormField<int>(
                      value: selectedFamilyId,
                      decoration:
                          const InputDecoration(labelText: "Keluarga"),
                      items: families.map((f) {
                        return DropdownMenuItem<int>(
                          value: f.id,
                          child: Text(f.name),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => selectedFamilyId = v),
                      validator: (v) =>
                          v == null ? "Pilih keluarga" : null,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
