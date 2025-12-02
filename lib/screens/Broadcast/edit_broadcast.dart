// lib/screens/Broadcast/edit_broadcast.dart
import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/broadcast/tambah_broadcast_form.dart';

class EditBroadcastScreen extends StatelessWidget {
  final Map<String, dynamic> broadcastData;
  const EditBroadcastScreen({super.key, required this.broadcastData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Broadcast")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TambahBroadcastForm(initialData: broadcastData, isEdit: true),
      ),
    );
  }
}