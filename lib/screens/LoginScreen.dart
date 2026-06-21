import 'package:flutter/material.dart';
import 'package:knowledges_gate/Routes.dart';
import 'package:knowledges_gate/helpers/AppTheme.dart';
import 'package:knowledges_gate/helpers/SharedResource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Get.offAllNamed(Routes.QUESTIONROUTE);
    } on FirebaseAuthException {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Top decoration ──────────────────────────────
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Image.asset('Assets/flutter_logo.png'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Title ───────────────────────────────────────
              Text('Welcome\nBack! 👋', style: AppTextStyles.heading1),
              const SizedBox(height: 6),
              Text(
                'Log in to continue your quiz journey.',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: 32),

              // ── Email field ──────────────────────────────────
              _FieldLabel('Email address'),
              const SizedBox(height: 8),
              PopScope(
                canPop: false,
                child: AppTextField(
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 18),

              // ── Password field ───────────────────────────────
              _FieldLabel('Password'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'enter your password',
                obscure: _obscurePassword,
                controller: _passwordController,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Login button ─────────────────────────────────
              PrimaryButton(
                label: 'Log In',
                isLoading: _isLoading,
                onTap: _onLogin,
              ),

              const SizedBox(height: 16),

              // ── Divider ──────────────────────────────────────
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 28),

              // ── Sign up link ─────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.SIGNUPROUTE),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppTextStyles.caption,
                      children: [
                        TextSpan(text: 'Sign Up', style: AppTextStyles.label),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
