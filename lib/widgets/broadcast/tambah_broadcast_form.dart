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

  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController senderController;

  bool isLoading = false;

  // sementara (nanti ambil dari token/login)
  final int fixedSenderId = 1;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
        text: widget.initialData?['title']?.toString() ?? '');
    contentController = TextEditingController(
        text: widget.initialData?['content']?.toString() ?? '');
    senderController = TextEditingController(
        text: widget.initialData?['sender']?.toString() ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    senderController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      Map<String, dynamic> response;

      if (widget.isEdit) {
        final idRaw = widget.initialData?['id'];
        final id = (idRaw is int)
            ? idRaw
            : int.tryParse(idRaw?.toString() ?? '');

        if (id == null) {
          setState(() => isLoading = false);
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("ID tidak ditemukan")));
          return;
        }

        // ========================
        //       UPDATE
        // ========================
        response = await BroadcastService.updateBroadcast(
          id: id,
          title: titleController.text,
          content: contentController.text,
          senderId: fixedSenderId, // FIXED
        );
      } else {
        // ========================
        //       CREATE
        // ========================
        response = await BroadcastService.createBroadcast(
          title: titleController.text,
          content: contentController.text,
          senderId: fixedSenderId, // FIXED
        );
      }

      setState(() => isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.isEdit
                ? "Broadcast berhasil diperbarui!"
                : "Broadcast berhasil dibuat!")),
      );

      context.pop(response);

    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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

          TextFormField(
            controller: contentController,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: "Isi Pesan",
              border: OutlineInputBorder(),
            ),
            validator: (val) =>
                val == null || val.isEmpty ? "Isi pesan harus diisi" : null,
          ),
          const SizedBox(height: 16),

          // Tampilkan pengirim sebagai informasi saja
          TextFormField(
            controller: senderController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Pengirim (otomatis)",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.isEdit
                      ? "Perbarui Broadcast"
                      : "Kirim Broadcast"),
            ),
          ),
        ],
      ),
    );
  }
}