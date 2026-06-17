import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../routes.dart';
import '../services/providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppTheme.primary.withOpacity(0.4),
                  AppTheme.background,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.containerPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: AppTheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'BioDigit',
                      style: TextStyle(
                        fontSize: 28,
                        height: 36 / 28,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Biodigester Monitoring — Burkina Faso',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.onSurface.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: AppTheme.sectionMargin),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 22,
                              height: 28 / 22,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email Field
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Error message
                          Consumer<AuthProvider>(
                            builder: (_, auth, __) {
                              if (auth.error != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    auth.error!,
                                    style: const TextStyle(color: AppTheme.error, fontSize: 13),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Sign In Button
                          Consumer<AuthProvider>(
                            builder: (ctx, auth, __) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading ? null : () async {
                                    final success = await auth.signIn(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                    );
                                    if (success && ctx.mounted) {
                                      final role = auth.user?.role ?? 'user';
                                      if (role == 'admin') {
                                        Navigator.pushReplacementNamed(ctx, AppRoutes.adminDashboard);
                                      } else {
                                        Navigator.pushReplacementNamed(ctx, AppRoutes.mainDashboard);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: auth.isLoading
                                      ? const SizedBox(
                                          height: 20, width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Sign In'),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.arrow_forward, size: 18),
                                          ],
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: AppTheme.outlineVariant),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'or continue with',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: AppTheme.outlineVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Social Login Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.g_mobiledata,
                                      size: 20),
                                  label: const Text('Google'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.facebook,
                                      size: 20, color: Color(0xFF1877F2)),
                                  label: const Text('Facebook'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Sign Up Link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _footerLink('Privacy Policy'),
                        const SizedBox(width: 16),
                        _footerLink('Terms of Service'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2024 BioSmart Africa • Plateau Central, Burkina Faso',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: AppTheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}
