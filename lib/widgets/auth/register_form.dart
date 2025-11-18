// lib/widgets/auth/register_form.dart

import 'package:flutter/material.dart';
import 'package:jawaramobile_1/theme/AppTheme.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController namaController,
      nikController,
      emailController,
      phoneController,
      passwordController,
      confirmPasswordController,
      alamatController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.namaController,
    required this.nikController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.alamatController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(theme, 'Nama'),
            const SizedBox(height: 8),
            TextFormField(
              controller: namaController,
              decoration: _inputDecoration('Masukkan nama disini'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            _label(theme, 'NIK'),
            const SizedBox(height: 8),
            TextFormField(
              controller: nikController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Masukkan NIK disini'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'NIK tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            _label(theme, 'Email'),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Masukkan email disini'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _label(theme, 'Nomor Telepon'),
            const SizedBox(height: 8),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('Masukkan nomor telepon disini'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            _label(theme, 'Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: _inputDecoration('Masukkan password disini').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _label(theme, 'Konfirmasi Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscurePassword,
              decoration: _inputDecoration('Masukkan konfirmasi password disini')
                  .copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                if (value != passwordController.text) {
                  return 'Konfirmasi password tidak sesuai';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onRegister,
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.85),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: AppTheme.primaryOrange, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
