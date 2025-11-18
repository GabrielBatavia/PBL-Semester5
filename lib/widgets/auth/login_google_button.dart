// lib/widgets/auth/login_google_button.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class LoginGoogleButton extends StatelessWidget {
  final VoidCallback onTap;

  const LoginGoogleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryOrange.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kalau nanti mau ganti asset lokal ikon Google juga gampang
              Image.network(
                'https://www.google.com/favicon.ico',
                width: 22,
                height: 22,
                errorBuilder: (context, _, __) {
                  return const Icon(Icons.g_mobiledata, size: 24);
                },
              ),
              const SizedBox(width: 12),
              Text(
                'Google',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkBrown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
