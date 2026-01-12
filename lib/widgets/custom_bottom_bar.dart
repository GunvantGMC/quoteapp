import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar for the inspirational quote app.
/// Implements thumb-optimized bottom placement for one-handed operation.
///
/// This widget is parameterized and reusable across different implementations.
/// Navigation logic is NOT hardcoded - it uses callbacks for flexibility.
///
/// Design Philosophy: Contemporary Mindful Minimalism
/// - Minimal visual noise with purposeful spacing
/// - Thumb-friendly touch targets (minimum 48dp)
/// - Clear visual hierarchy with active/inactive states
/// - Haptic feedback integration for tactile confirmation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a navigation item is tapped
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          items: [
            // Home Tab - Quote Discovery Screen
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home, size: 24),
              ),
              label: 'Home',
              tooltip: 'Quote Discovery',
            ),

            // Favorites Tab - Saved Quotes Collection
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.favorite_outline, size: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.favorite, size: 24),
              ),
              label: 'Favorites',
              tooltip: 'Saved Quotes',
            ),
          ],
        ),
      ),
    );
  }
}
