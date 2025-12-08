import 'package:flutter/material.dart';

class KirimPesanScreen extends StatefulWidget {
  const KirimPesanScreen({super.key});

  @override
  State<KirimPesanScreen> createState() => _KirimPesanScreenState();
}

class _KirimPesanScreenState extends State<KirimPesanScreen> {
  final namaCtrl = TextEditingController();
  final pesanCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Kirim Pesan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Kirim Pesan",
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: Colors.white, fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  "Sampaikan pesan atau keluhan Anda kepada pengurus RW.",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ),

              const SizedBox(height: 10),

              // WHITE FORM CONTAINER
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: namaCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pesanCtrl,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Isi Pesan",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A11CB),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Kirim",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}