import 'package:flutter/material.dart';
import '../../models/family_model.dart';
import '../../models/house_model.dart';
import '../../models/mutations_model.dart';
import '../../services/family_service.dart';
import '../../services/house_service.dart';
import '../../services/mutation_service.dart';

class MutasiFormPage extends StatefulWidget {
  final MutasiModel? existing;

  const MutasiFormPage({super.key, this.existing});

  @override
  State<MutasiFormPage> createState() => _MutasiFormPageState();
}

class _MutasiFormPageState extends State<MutasiFormPage> {
  final _formKey = GlobalKey<FormState>();

  final familyService = FamilyService.instance;
  final houseService = HouseService.instance;
  final mutasiService = MutasiService.instance;

  List<FamilyModel> families = [];
  List<HouseModel> houses = [];

  int? familyId;
  String? newAddress;
  String? mutationType;
  String? reason;
  String? date;

  // FIXED → controller biar alamat lama otomatis update
  final oldAddressC = TextEditingController();

  bool loadingFamilies = true;
  bool loadingHouses = true;

  @override
  void initState() {
    super.initState();
    loadFamilies();
    loadHouses();

    if (widget.existing != null) {
      final m = widget.existing!;
      familyId = m.familyId;
      oldAddressC.text = m.oldAddress ?? "";
      newAddress = m.newAddress;
      mutationType = m.mutationType;
      reason = m.reason;
      date = m.date;
    }
  }

  @override
  void dispose() {
    oldAddressC.dispose();
    super.dispose();
  }

  void loadFamilies() async {
    families = await familyService.fetchFamilies();
    setState(() => loadingFamilies = false);
  }

  void loadHouses() async {
    houses = await houseService.fetchHouses();
    setState(() => loadingHouses = false);
  }

  // FIXED: alamat lama otomatis berdasarkan houseId milik keluarga
  void onFamilySelected(int? id) {
    setState(() {
      familyId = id;

      final fam = families.firstWhere(
        (f) => f.id == id,
        orElse: () => FamilyModel(id: 0, name: "", houseId: null, status: ""),
      );

      // Cari rumah
      if (fam.houseId != null) {
        final house = houses.firstWhere(
          (h) => h.id == fam.houseId,
          orElse: () => HouseModel(id: 0, address: ""),
        );
        oldAddressC.text = house.address;
      } else {
        oldAddressC.text = "";
      }
    });
  }

  void save() async {
    if (!_formKey.currentState!.validate()) return;

    final data = MutasiModel(
      id: widget.existing?.id ?? 0,
      familyId: familyId!,
      oldAddress: oldAddressC.text,
      newAddress: newAddress ?? "",
      mutationType: mutationType!,
      reason: reason ?? "",
      date: date!,
    );

    if (widget.existing == null) {
      await mutasiService.create(data);
    } else {
      await mutasiService.update(data.id!, data);
    }

    if (mounted) Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existing == null ? "Tambah Mutasi" : "Edit Mutasi"),
      ),
      body: loadingFamilies || loadingHouses
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<int>(
                      value: familyId,
                      decoration: const InputDecoration(
                        labelText: "Keluarga",
                        border: OutlineInputBorder(),
                      ),
                      items: families
                          .map((f) => DropdownMenuItem(
                                value: f.id,
                                child: Text("${f.name} (ID: ${f.id})"),
                              ))
                          .toList(),
                      onChanged: onFamilySelected,
                      validator: (v) =>
                          v == null ? "Pilih keluarga" : null,
                    ),
                    
                    const SizedBox(height: 16),

                    // FIXED: controller, bukan initialValue
                    TextFormField(
                      readOnly: true,
                      controller: oldAddressC,
                      decoration: const InputDecoration(
                        labelText: "Alamat Lama",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: newAddress,
                      decoration: const InputDecoration(
                        labelText: "Alamat Baru",
                        border: OutlineInputBorder(),
                      ),
                      items: houses
                          .map((h) => DropdownMenuItem(
                                value: h.address,
                                child: Text(h.address),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => newAddress = val),
                      validator: (v) =>
                          v == null ? "Pilih alamat baru" : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: mutationType,
                      decoration: const InputDecoration(
                        labelText: "Jenis Mutasi",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "masuk", child: Text("Masuk")),
                        DropdownMenuItem(
                            value: "keluar", child: Text("Keluar")),
                        DropdownMenuItem(
                            value: "pindah", child: Text("Pindah")),
                      ],
                      onChanged: (v) => setState(() => mutationType = v),
                      validator: (v) =>
                          v == null ? "Pilih jenis mutasi" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: date,
                      decoration: const InputDecoration(
                        labelText: "Tanggal (YYYY-MM-DD)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => date = v,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Masukkan tanggal" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: reason,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Alasan",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => reason = v,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan"),
                      onPressed: save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
