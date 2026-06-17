import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../models/biodigester_model.dart';
import '../routes.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.mockUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.farmName,
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            // Profile info cards
            Padding(
              padding: const EdgeInsets.all(AppTheme.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact info
                  _sectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(Icons.email, 'Email', user.email),
                    _infoRow(Icons.phone, 'Phone', user.phone),
                    _infoRow(Icons.badge, 'ID', user.id),
                  ]),
                  const SizedBox(height: 24),
                  // Quick stats
                  _sectionTitle('Farm Overview'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _quickStat('124', 'Cattle', Icons.pets, AppTheme.primary),
                      const SizedBox(width: 12),
                      _quickStat('86', 'Swine', Icons.grid_view, AppTheme.secondary),
                      const SizedBox(width: 12),
                      _quickStat('2', 'Digesters', Icons.storage, AppTheme.tertiary),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Biodigester Capacity & Production
                  _sectionTitle('Biodigester Statistics'),
                  const SizedBox(height: 12),
                  _biodigesterStats(),
                  const SizedBox(height: 24),
                  // Actions
                  _sectionTitle('Quick Actions'),
                  const SizedBox(height: 12),
                  _actionRow(Icons.analytics, 'View Reports', AppRoutes.reports, AppTheme.primary),
                  _actionRow(Icons.settings, 'Settings', AppRoutes.settings, AppTheme.onSurfaceVariant),
                  _actionRow(Icons.help_outline, 'Help & Support', '', AppTheme.tertiary),
                  const SizedBox(height: 24),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false),
                      icon: const Icon(Icons.logout, color: AppTheme.error),
                      label: const Text('Sign Out', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.2))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, Icons.home, 'Home', AppRoutes.mainDashboard, false),
                _navItem(context, Icons.sensors, 'Live', AppRoutes.liveMonitoring, false),
                _navItem(context, Icons.notifications_active_outlined, 'Alerts', AppRoutes.alerts, false),
                _navItem(context, Icons.insights_outlined, 'History', AppRoutes.history, false),
                _navItem(context, Icons.person, 'Profile', AppRoutes.userProfile, true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.onSurface));
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.outline)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickStat(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _biodigesterStats() {
    final bio = BiodigesterModel.mockBiodigester;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _bioStat(Icons.storage, 'Capacity', '${bio.capacity} m³', AppTheme.primary),
              const SizedBox(width: 12),
              _bioStat(Icons.trending_up, 'Efficiency', '${bio.efficiency}%', AppTheme.tertiary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _bioStat(Icons.bolt, 'Energy', '${bio.energyGenerated} kWh', AppTheme.secondary),
              const SizedBox(width: 12),
              _bioStat(Icons.eco, 'CO₂ Saved', '${bio.co2Reduction.toInt()} kg', const Color(0xFF2E7D32)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _bioStat(Icons.calendar_today, 'Today', '${bio.todayProduction} m³', AppTheme.primary),
              const SizedBox(width: 12),
              _bioStat(Icons.calendar_view_week, 'Weekly', '${bio.weeklyProduction} m³', AppTheme.tertiary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _bioStat(Icons.calendar_month, 'Monthly', '${bio.monthlyProduction} m³', AppTheme.secondary),
              const SizedBox(width: 12),
              _bioStat(Icons.calendar_view_month, 'Yearly', '${bio.yearlyProduction} m³', AppTheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bioStat(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.outline)),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _actionRow(IconData icon, String label, String route, Color color) {
    return Builder(
      builder: (context) => InkWell(
        onTap: route.isNotEmpty ? () => Navigator.pushNamed(context, route) : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.onSurface))),
              const Icon(Icons.chevron_right, size: 20, color: AppTheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route, bool selected) {
    return InkWell(
      onTap: selected ? null : () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: selected
            ? BoxDecoration(color: AppTheme.primaryContainer.withOpacity(0.1), borderRadius: BorderRadius.circular(9999))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
