import 'package:flutter/material.dart';
import 'package:jawaramobile_1/services/broadcast_service.dart';
import 'package:go_router/go_router.dart';

class TambahBroadcastForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  const TambahBroadcastForm({
    super.key,
    this.initialData,
    this.isEdit = false,
  });

  @override
  State<TambahBroadcastForm> createState() => _TambahBroadcastFormState();
}

class _TambahBroadcastFormState extends State<TambahBroadcastForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  int? senderId; // **FIXED: pakai sender_id**

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.initialData?["title"] ?? "";
    contentController.text = widget.initialData?["content"] ?? "";

    senderId = widget.initialData?["sender_id"] ?? 1; 
    // NOTE: Ganti 1 dengan user login (nanti saya bantu kalau mau)
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (senderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sender ID tidak valid")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Map<String, dynamic> payload = {
        "title": titleController.text,
        "content": contentController.text,
        "sender_id": senderId, // **PENTING**
      };

      Map<String, dynamic>? response;

      if (widget.isEdit) {
        response = await BroadcastService.updateBroadcast(
          id: widget.initialData!["id"],
          title: titleController.text,
          content: contentController.text,
          senderId: senderId!,
        );
      } else {
        response = await BroadcastService.createBroadcast(
          title: titleController.text,
          content: contentController.text,
          senderId: senderId!,
        );
      }

      setState(() => isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Broadcast berhasil disimpan")),
      );

      context.pop(response);

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // === INPUT JUDUL ===
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Judul Broadcast",
              border: OutlineInputBorder(),
            ),
            validator: (val) =>
                val == null || val.isEmpty ? "Judul harus diisi" : null,
          ),
          const SizedBox(height: 16),

          // === INPUT ISI ===
          TextFormField(
            controller: contentController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Isi Pesan",
              border: OutlineInputBorder(),
            ),
            validator: (val) =>
                val == null || val.isEmpty ? "Isi pesan harus diisi" : null,
          ),
          const SizedBox(height: 24),

          // === TOMBOL SIMPAN ===
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.isEdit ? "Perbarui Broadcast" : "Kirim Broadcast"),
            ),
          ),
        ],
      ),
    );
  }
}