// lib/screens/Auth/login_screens.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile_1/services/auth_service.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.login(email, password);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Login gagal. Periksa email/password atau status akun.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                      // <-- penting: pakai _isLoading
                      onLogin: _isLoading ? null : _handleLogin,
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading) ...[
                      const CircularProgressIndicator(),
                    ] else ...[
                      const LoginDivider(),
                      const SizedBox(height: 16),
                      LoginGoogleButton(onTap: _handleGoogleLogin),
                      const SizedBox(height: 16),
                      LoginRegisterLink(onTap: _handleDaftar),
                      const SizedBox(height: 4),
                      Text(
                        'Terhubung ke server FastAPI – autentikasi JWT',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
