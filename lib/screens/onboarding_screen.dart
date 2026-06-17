import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Biogas Production',
      subtitle: 'RENEWABLE ENERGY',
      description:
          'Convert livestock waste into clean biogas. Monitor daily production in m³, track efficiency, and reduce CO₂ emissions across your farm.',
      icon: Icons.eco,
      tagLabel: 'Up to 8.4 m³/day',
      imageColor: AppTheme.primaryContainer,
    ),
    _OnboardingPage(
      title: 'Real-Time IoT Monitoring',
      subtitle: 'ESP32 + SENSORS',
      description:
          'Track temperature (DS18B20), pressure (BMP280), methane (MQ-4), and slurry level (HC-SR04) with live sync via Firebase.',
      icon: Icons.sensors,
      tagLabel: '4 Sensors Live',
      imageColor: AppTheme.primary,
    ),
    _OnboardingPage(
      title: 'AI Anomaly Detection',
      subtitle: 'PREDICTIVE INTELLIGENCE',
      description:
          'Machine learning detects leaks, pressure spikes, and sensor drift before they become critical — with smart alerts in Français, Mooré, or Dioula.',
      icon: Icons.notifications_active,
      tagLabel: 'AI Powered',
      imageColor: AppTheme.tertiary,
    ),
    _OnboardingPage(
      title: 'Farm Management',
      subtitle: 'BURKINA FASO',
      description:
          'Manage feeding schedules, organic waste tracking, livestock, and biodigester performance — all adapted for Plateau Central.',
      icon: Icons.agriculture,
      tagLabel: 'Local Context',
      imageColor: AppTheme.secondary,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.containerPadding,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BioDigit',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    _buildPage(_pages[index]),
              ),
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.containerPadding,
                16,
                AppTheme.containerPadding,
                32,
              ),
              child: Column(
                children: [
                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? AppTheme.primary
                              : AppTheme.outlineVariant,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next'),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;
        final illusSize = (h * 0.38).clamp(140.0, 260.0);
        final iconSize = (illusSize * 0.46).clamp(48.0, 120.0);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: h),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: h * 0.08),
                  Container(
                    width: illusSize,
                    height: illusSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: page.imageColor.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: page.imageColor.withOpacity(0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            page.icon,
                            size: iconSize,
                            color: page.imageColor,
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(page.icon, size: 16, color: AppTheme.primary),
                                const SizedBox(width: 4),
                                Text(
                                  page.tagLabel,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.06),
                  if (page.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        page.subtitle.toUpperCase(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.primary, letterSpacing: 2),
                      ),
                    ),
                  Text(
                    page.title,
                    style: TextStyle(
                      fontSize: (w * 0.07).clamp(20.0, 28.0),
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: (w * 0.04).clamp(13.0, 16.0), height: 1.5, letterSpacing: 0.5, color: AppTheme.onSurfaceVariant),
                  ),
                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String tagLabel;
  final Color imageColor;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.tagLabel,
    required this.imageColor,
  });
}
