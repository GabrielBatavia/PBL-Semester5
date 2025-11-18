// lib/widgets/auth/login_header.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryOrange, Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.menu_book, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Text(
          'Jawara Pintar',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkBrown,
          ),
        ),
      ],
    );
  }
}
