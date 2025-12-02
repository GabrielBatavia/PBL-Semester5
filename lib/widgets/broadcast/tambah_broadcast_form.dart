import 'package:flutter/material.dart';
import 'package:jawaramobile_1/services/broadcast_service.dart';
import 'package:go_router/go_router.dart';

class TambahBroadcastForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  const TambahBroadcastForm({super.key, this.initialData, this.isEdit = false});

  @override
  State<TambahBroadcastForm> createState() => _TambahBroadcastFormState();
}

class _TambahBroadcastFormState extends State<TambahBroadcastForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController senderController;

  bool isLoading = false;
  final int fixedSenderId = 1;

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.initialData?['title'] ?? '');
    contentController =
        TextEditingController(text: widget.initialData?['content'] ?? '');
    senderController =
        TextEditingController(text: widget.initialData?['sender_name'] ?? 'Anda');
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
      Map<String, dynamic> resp;

      if (widget.isEdit) {
        final id = widget.initialData?['id'];
        resp = await BroadcastService.updateBroadcast(
          id: id,
          title: titleController.text,
          content: contentController.text,
          senderId: fixedSenderId,
        );
      } else {
        resp = await BroadcastService.createBroadcast(
          title: titleController.text,
          content: contentController.text,
          senderId: fixedSenderId,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? "Broadcast diperbarui" : "Broadcast dibuat")),
      );

      context.pop(resp);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => isLoading = false);
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
                labelText: "Judul Broadcast", border: OutlineInputBorder()),
            validator: (v) => v == null || v.isEmpty ? "Judul wajib diisi" : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: contentController,
            maxLines: 6,
            decoration: const InputDecoration(
                labelText: "Isi Pesan", border: OutlineInputBorder()),
            validator: (v) => v == null || v.isEmpty ? "Isi wajib diisi" : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: senderController,
            readOnly: true,
            decoration: const InputDecoration(
                labelText: "Pengirim (otomatis)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : Text(widget.isEdit ? "Perbarui" : "Kirim"),
            ),
          ),
        ],
      ),
    );
  }
}