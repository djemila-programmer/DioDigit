import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    this.title = 'BioDigit',
    this.showBackButton = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface.withValues(alpha: 0.8),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.containerPadding,
            vertical: AppTheme.baseSpacing,
          ),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                ),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryContainer,
                child: const Icon(Icons.eco, color: AppTheme.onPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title ?? 'BioDigit',
                style: const TextStyle(
                  fontSize: 22,
                  height: 28 / 22,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                icon: const Icon(Icons.notifications, color: AppTheme.onSurfaceVariant),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
