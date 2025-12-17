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

  List<FamilyModel> families = [];
  int? selectedFamilyId;

  @override
  void initState() {
    super.initState();

    if (widget.existingData != null) {
      final r = widget.existingData!;
      nameController.text = r.name;
      nikController.text = r.nik ?? "";
      jobController.text = r.job ?? "";
      birthController.text = r.birthDate ?? "";
      gender = r.gender;
    }
    _loadFamilies();
}


  void _loadFamilies() async {
    families = await FamilyService.instance.fetchFamilies();
    setState(() {});
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final resident = ResidentModel(
      id: 0,
      name: nameController.text,
      nik: nikController.text,
      birthDate: birthController.text,
      job: jobController.text,
      gender: gender,
      familyId: selectedFamilyId,
      userId: null,
    );

    final success = await ResidentService.instance.createResident(resident);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data warga berhasil ditambahkan")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambah warga")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Data Warga")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      decoration: const InputDecoration(labelText: "Tanggal Lahir"),
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

                    DropdownButtonFormField(
                      decoration:
                          const InputDecoration(labelText: "Jenis Kelamin"),
                      items: const [
                        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "P", child: Text("Perempuan")),
                      ],
                      onChanged: (v) => gender = v,
                    ),

                    DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: "Keluarga"),
                      items: families.map((f) {
                        return DropdownMenuItem<int>(
                          value: f.id,
                          child: Text(f.name),
                        );
                      }).toList(),
                      onChanged: (v) => selectedFamilyId = v,
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
