import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/citizen_request_model.dart';
import '../../services/citizen_request_service.dart';

class CitizenRequestFormPage extends StatefulWidget {
  final CitizenRequestModel? data;

  const CitizenRequestFormPage({super.key, this.data});

  @override
  State<CitizenRequestFormPage> createState() => _CitizenRequestFormPageState();
}

class _CitizenRequestFormPageState extends State<CitizenRequestFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController nikC;
  late TextEditingController emailC;

  String? gender;
  String status = "pending";
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController(text: widget.data?.name ?? "");
    nikC = TextEditingController(text: widget.data?.nik ?? "");
    emailC = TextEditingController(text: widget.data?.email ?? "");
    gender = widget.data?.gender;
    status = widget.data?.status ?? "pending";
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final req = CitizenRequestModel(
      id: widget.data?.id,
      name: nameC.text,
      nik: nikC.text,
      email: emailC.text,
      gender: gender ?? "",
      status: status,
      identityImageUrl: widget.data?.identityImageUrl,
    );

    bool success;

    if (widget.data == null) {
      success = await CitizenRequestService().createWithImage(req, selectedImage);
    } else {
      success = await CitizenRequestService()
          .updateWithImage(widget.data!.id!, req, selectedImage);
    }

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.data == null ? "Tambah Pengajuan" : "Edit Pengajuan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: nikC,
                decoration: const InputDecoration(labelText: "NIK"),
              ),
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                onChanged: (val) => gender = val,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "pending", child: Text("Pending")),
                  DropdownMenuItem(value: "approved", child: Text("Disetujui")),
                  DropdownMenuItem(value: "rejected", child: Text("Ditolak")),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              Text(
                "Foto KTP / Identitas",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : widget.data?.identityImageUrl != null
                          ? Image.network(widget.data!.identityImageUrl!)
                          : const Center(child: Text("Tap untuk pilih gambar")),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submit,
                child: Text(widget.data == null ? "Simpan" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
