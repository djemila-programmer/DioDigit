import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    final user = UserModel.mockUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
        ),
        title: const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.primary)),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications, color: AppTheme.onSurfaceVariant),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.primaryContainer.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: AppTheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                        Text(user.email, style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.outline),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Account section
            _sectionTitle('Account'),
            const SizedBox(height: 12),
            _settingsTile(Icons.security, 'Security', 'Password, 2FA', () {}),
            _settingsTile(Icons.wifi, 'ESP32 Connection', 'Connected · 192.168.1.100', () {}),
            _settingsTile(Icons.notifications_outlined, 'Notifications', 'Alerts & push settings', () {}),
            const SizedBox(height: 24),
            // Preferences section
            _sectionTitle('Preferences'),
            const SizedBox(height: 12),
            // Language
            _languageTile(),
            // Dark mode
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.dark_mode, size: 20, color: AppTheme.tertiary),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Dark Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
                  ),
                  Switch(
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                    activeColor: AppTheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Support section
            _sectionTitle('Support'),
            const SizedBox(height: 12),
            _settingsTile(Icons.help_outline, 'Help Center', 'FAQs & guides', () {}),
            _settingsTile(Icons.info_outline, 'About', 'Version 2.1.0', () {}),
            _settingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', 'Data & permissions', () {}),
            const SizedBox(height: 32),
            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false),
                icon: const Icon(Icons.logout, color: AppTheme.error),
                label: const Text('Sign Out', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant, letterSpacing: 0.5));
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppTheme.outline),
          ],
        ),
      ),
    );
  }

  Widget _languageTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.language, size: 20, color: AppTheme.secondary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Language', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
            items: ['Français', 'Mooré', 'Dioula', 'English'].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedLanguage = value);
            },
          ),
        ],
      ),
    );
  }
}
