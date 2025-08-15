import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon
                Icon(Icons.shopping_cart_rounded,
                    size: size.width * 0.2, color: Colors.deepPurple),
                const SizedBox(height: 16),

                Text(
                  isRegister ? t.t('register') : t.t('sign in'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isRegister
                      ? t.t('Create Account')
                      : t.t('Welcome Back'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: t.t('email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                      filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: pass,
                  decoration: InputDecoration(
                    labelText: t.t('password'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Main button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                      if (isRegister) {
                        await auth.registerWithEmail(
                            email.text.trim(), pass.text.trim());
                      } else {
                        await auth.signInWithEmail(
                            email.text.trim(), pass.text.trim());
                      }
                      if (mounted) {
                        Navigator.pushReplacementNamed(
                            context, Routes.home);
                      }
                    },
                    child: Text(
                      isRegister ? t.t('register') : t.t('sign in'),
                      style: const TextStyle(fontSize: 18,color: Colors.white,),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Google Sign-in
                // Replace this part of the UI with the updated icon and styling
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJg75LWB1zIJt1VTZO7O68yKciaDSkk3KMdw&s',
                      width: 30,
                      height: 30,
                    ),
                    label: Text(t.t('google sign in')),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: auth.isLoading ? null : () async {
                      await auth.loginWithGoogle();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Toggle between Login & Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRegister
                          ? t.t('Already Have Account')
                          : t.t('No Account'),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => isRegister = !isRegister),
                      child: Text(
                        isRegister ? t.t('Sign in') : t.t('register'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
