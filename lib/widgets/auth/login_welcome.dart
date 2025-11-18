// lib/widgets/auth/login_welcome.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class LoginWelcome extends StatelessWidget {
  const LoginWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'Selamat Datang!',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 24,
            color: AppTheme.darkBrown,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Login untuk mengakses sistem Jawara Pintar',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
