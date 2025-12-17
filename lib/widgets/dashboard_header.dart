// lib/widgets/dashboard_header.dart
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String role;

  const DashboardHeader({super.key, required this.role});

  String get _roleLabel {
    switch (role) {
      case 'rt':
        return 'Ketua RT';
      case 'rw':
        return 'Ketua RW';
      case 'bendahara':
        return 'Bendahara';
      case 'sekretaris':
        return 'Sekretaris';
      case 'admin':
        return 'Admin Sistem';
      default:
        return 'Warga';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            child: Text(
              _roleLabel[0],
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hai, $_roleLabel', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Welcome Back 👋',
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.notifications_none),
        ],
      ),
    );
  }
}
