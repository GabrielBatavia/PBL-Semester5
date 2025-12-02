import 'package:flutter/material.dart';
import 'package:jawaramobile_1/widgets/broadcast/tambah_broadcast_form.dart';

class TambahBroadcastScreen extends StatelessWidget {
  const TambahBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Broadcast")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: Colors.white,
          child: const TambahBroadcastForm(),
        ),
      ),
    );
  }
}