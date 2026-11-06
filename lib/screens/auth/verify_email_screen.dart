import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  Future<void> _check(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    await auth.checkVerification();
    if (!auth.isVerified && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email not verified yet. Check your inbox.')));
    }
  }

  Future<void> _resend(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.resendVerification();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok
              ? 'Verification email sent.'
              : (auth.error ?? 'Could not send email.'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mark_email_unread_outlined,
                  size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Verify your email',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to\n${auth.firebaseUser?.email ?? ''}\n\n'
                'Open it, then tap the button below.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                  label: "I've verified my email",
                  onPressed: () => _check(context),
                  loading: auth.loading),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () => _resend(context),
                  child: const Text('Resend email')),
              TextButton(
                  onPressed: auth.logout,
                  child: const Text('Use a different account')),
            ],
          ),
        ),
      ),
    );
  }
}