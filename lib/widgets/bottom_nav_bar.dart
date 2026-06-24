import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home, filledIcon: Icons.home, label: 'Home', route: AppRoutes.mainDashboard),
    _NavItem(icon: Icons.sensors, filledIcon: Icons.sensors, label: 'Live', route: AppRoutes.liveMonitoring),
    _NavItem(icon: Icons.notifications_active_outlined, filledIcon: Icons.notifications_active, label: 'Alerts', route: AppRoutes.alerts),
    _NavItem(icon: Icons.insights_outlined, filledIcon: Icons.insights, label: 'History', route: AppRoutes.history),
    _NavItem(icon: Icons.person_outline, filledIcon: Icons.person, label: 'Profile', route: AppRoutes.userProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = currentIndex == index;
              return _buildNavItem(context, item, isSelected, index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item, bool isSelected, int index) {
    return InkWell(
      onTap: () {
        if (currentIndex != index) {
          Navigator.pushNamed(context, item.route);
        }
      },
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9999),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.filledIcon : item.icon,
              color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                height: 16 / 11,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData filledIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.filledIcon,
    required this.label,
    required this.route,
  });
}
