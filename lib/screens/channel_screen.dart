import 'package:flutter/material.dart';

// Screen untuk menampilkan daftar Channel Komunikasi (Kontak RT/RW)
class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key});

  void _openWhatsapp(String number) {
    // TODO: implement launchUrl
    // launchUrl(Uri.parse("https://wa.me/$number"));
  }

  void _openPhone(String number) {
    // TODO: implement launchUrl
    // launchUrl(Uri.parse("tel:$number"));
  }

  void _openEmail(String email) {
    // TODO: implement launchUrl
    // launchUrl(Uri.parse("mailto:$email"));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> channels = [
      {
        "name": "WhatsApp RT",
        "icon": Icons.phone,
        "color": Colors.green,
        "detail": "0812-3456-7890",
        "onTap": () => _openWhatsapp("081234567890"),
      },
      {
        "name": "Telepon Ketua RT",
        "icon": Icons.phone,
        "color": Colors.blue,
        "detail": "021-555-1234",
        "onTap": () => _openPhone("0215551234"),
      },
      {
        "name": "Email RT/RW",
        "icon": Icons.email,
        "color": Colors.orange,
        "detail": "rt05rw12@example.com",
        "onTap": () => _openEmail("rt05rw12@example.com"),
      },
      {
        "name": "Grup Warga (Broadcast)",
        "icon": Icons.group,
        "color": Colors.purple,
        "detail": "Klik untuk gabung",
        "onTap": () {},
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Kanal Komunikasi RT/RW",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        ...channels.map((ch) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ch["color"].withOpacity(0.2),
                child: Icon(ch["icon"], color: ch["color"]),
              ),
              title: Text(
                ch["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ch["detail"]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: ch["onTap"],
            ),
          );
        }),
      ],
    );
  }
}
