import 'package:flutter/material.dart';
import 'package:knowledges_gate/Routes.dart';
import 'package:knowledges_gate/helpers/AppTheme.dart';
import 'package:knowledges_gate/helpers/SharedResource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Get.offAllNamed(Routes.QUESTIONROUTE);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              const SizedBox(height: 20),

              const SizedBox(height: 24),

              // ── Header ───────────────────────────────────────
              Text('Create\nAccount ✨', style: AppTextStyles.heading1),
              const SizedBox(height: 6),
              Text(
                'Join thousands of quiz lovers today.',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: 28),

              const SizedBox(height: 18),

              // ── Email ────────────────────────────────────────
              _FieldLabel('Email address'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'you@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // ── Password ─────────────────────────────────────
              _FieldLabel('Password'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Min. 8 characters',
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

              const SizedBox(height: 18),

              // ── Confirm password ─────────────────────────────
              _FieldLabel('Confirm password'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Repeat password',
                obscure: _obscureConfirm,
                controller: _confirmController,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Sign up button ───────────────────────────────
              PrimaryButton(
                label: 'Create Account',
                isLoading: _isLoading,
                onTap: _onSignUp,
              ),

              const SizedBox(height: 20),

              // ── Login link ───────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.caption,
                      children: [
                        TextSpan(text: 'Log In', style: AppTextStyles.label),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
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
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
  );
}
