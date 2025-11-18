// lib/screens/Auth/login_screens.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/auth/login_header.dart';
import '../../widgets/auth/login_welcome.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/login_divider.dart';
import '../../widgets/auth/login_google_button.dart';
import '../../widgets/auth/login_register_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // TODO: integrasi API / Firebase di sini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        context.go('/dashboard');
      });
    }
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In dalam pengembangan')),
    );
  }

  void _handleDaftar() {
    Future.delayed(const Duration(milliseconds: 50), () {
      context.go('/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoginHeader(),
                    const SizedBox(height: 32),
                    const LoginWelcome(),
                    const SizedBox(height: 32),
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onLogin: _handleLogin,
                    ),
                    const SizedBox(height: 24),
                    const LoginDivider(),
                    const SizedBox(height: 16),
                    LoginGoogleButton(onTap: _handleGoogleLogin),
                    const SizedBox(height: 16),
                    LoginRegisterLink(onTap: _handleDaftar),
                    const SizedBox(height: 4),
                    Text(
                      'Versi demo – autentikasi belum terhubung server',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
